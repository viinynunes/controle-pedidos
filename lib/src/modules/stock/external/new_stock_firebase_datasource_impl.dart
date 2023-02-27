import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/core/exceptions/external_exception.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/data/stock/stock_helper.dart';
import '../../../domain/models/product_model.dart';
import '../infra/datasources/i_new_stock_datasource.dart';

class NewStockFirebaseDatasourceImpl implements INewStockDatasource {
  final FirebaseFirestore firebase;

  late CollectionReference<Map<String, dynamic>> stockCollection;

  NewStockFirebaseDatasourceImpl({required this.firebase, String? companyID}) {
    stockCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('stock');
  }

  @override
  Future<StockModel> createStock(
      {required StockModel stock, String stockID = ''}) async {
    stockID.isNotEmpty
        ? await stockCollection.doc(stockID).set(stock.toMap()).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace))
        : await stockCollection.add(stock.toMap()).onError(
            (error, stackTrace) => throw ExternalException(
                error: error.toString(), stackTrace: stackTrace));

    StockModel? createdStock = await getStockByCode(code: stock.code);

    if (createdStock == null) {
      throw StockError('Stock não encontrado - CODE: ${stock.code}');
    }

    if (stockID.isEmpty) {
      return createdStock;
    }

    createdStock.id = stockID;

    return await updateStock(stock: createdStock);
  }

  @override
  Future<StockModel> deleteStock({required StockModel stock}) async {
    await stockCollection.doc(stock.id).delete().onError((error, stackTrace) =>
        throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    return stock;
  }

  @override
  Future<StockModel> updateStock({required StockModel stock}) async {
    await stockCollection.doc(stock.id).update(stock.toMap()).onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    return stock;
  }

  @override
  Future<void> updateStockFromProduct({required ProductModel product}) async {
    final stockSnap = await stockCollection
        .where('product.id', isEqualTo: product.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var s in stockSnap.docs) {
      ///old stock
      var stockFromDB = StockModel.fromDocumentSnapshot(s);

      final oldCode = stockFromDB.code;

      ///updating stock from db with updated product
      stockFromDB.product = product;
      stockFromDB.code = StockHelper.getStockCode(
          product: product, date: stockFromDB.registrationDate);

      if (oldCode != stockFromDB.code) {
        var stockWithNewCodeFromDB =
            await getStockByCode(code: stockFromDB.code);

        if (stockWithNewCodeFromDB != null) {
          stockWithNewCodeFromDB.total += stockFromDB.total;
          stockWithNewCodeFromDB.totalOrdered += stockFromDB.totalOrdered;

          await deleteStock(stock: stockFromDB);
          await updateStock(stock: stockWithNewCodeFromDB);
        } else {
          await updateStock(stock: stockFromDB);
        }
      } else {
        await updateStock(stock: stockFromDB);
      }
    }
  }

  @override
  Future<StockModel?> getStockByCode({required String code}) async {
    final result = await _getDocumentReferenceByCode(code);

    return result != null ? StockModel.fromDocumentSnapshot(result) : null;
  }

  @override
  Future<StockModel> getStockById({required String id}) async {
    var stockDoc = await stockCollection.doc(id).get().onError(
        (error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    if (stockDoc.exists) {
      return StockModel.fromDocumentSnapshot(stockDoc);
    }

    throw StockError('Stock ID - $id não encontrado');
  }

  @override
  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    Set<ProviderModel> providerList = {};

    final snapStock = await stockCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));
    for (var s in snapStock.docs) {
      providerList.add(ProviderModel.fromMap(map: s.get('product.provider')));
    }

    return providerList;
  }

  @override
  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) async {
    List<StockModel> stockList = [];

    final snap = await stockCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var doc in snap.docs) {
      stockList.add(StockModel.fromDocumentSnapshot(doc));
    }

    return stockList;
  }

  @override
  Future<List<StockModel>> getStockListByProviderBetweenDates({
    required ProviderModel provider,
    required DateTime iniDate,
    required DateTime endDate,
  }) async {
    List<StockModel> stockList = [];

    final snap = await stockCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .where('product.provider.id', isEqualTo: provider.id)
        .get()
        .onError((error, stackTrace) => throw ExternalException(
            error: error.toString(), stackTrace: stackTrace));

    for (var doc in snap.docs) {
      stockList.add(StockModel.fromDocumentSnapshot(doc));
    }

    return stockList;
  }

  Future<QueryDocumentSnapshot?> _getDocumentReferenceByCode(
      String code) async {
    final result = await stockCollection
        .where('code', isEqualTo: code)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET STOCK BY CODE ERROR', message: e.toString()));

    if (result.docs.length > 1) {
      throw ExternalException(
          error: 'GET STOCK BY CODE ERROR - More then one document was found');
    }

    if (result.docs.length == 1) {
      return result.docs.first;
    }

    return null;
  }
}
