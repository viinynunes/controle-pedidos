import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:get_storage/get_storage.dart';

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
        ? await stockCollection.doc(stockID).set(stock.toMap()).catchError(
            (e) => throw FirebaseException(
                plugin: 'CREATE STOCK ERROR', message: e.toString()))
        : await stockCollection
            .add(stock.toMap())
            .catchError((e) => throw FirebaseException(
                plugin: 'CREATE STOCK ERROR', message: e.toString()))
            .then((value) => stockID = value.id);

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
    await stockCollection.doc(stock.id).delete().catchError((e) =>
        throw FirebaseException(
            plugin: 'DELETE STOCK ERROR', message: e.toString()));

    return stock;
  }

  @override
  Future<StockModel> updateStock({required StockModel stock}) async {
    await stockCollection.doc(stock.id).update(stock.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'UPDATE STOCK ERROR', message: e.toString()));

    return stock;
  }

  @override
  Future<StockModel?> getStockByCode({required String code}) async {
    final result = await _getDocumentReferenceByCode(code);

    return result != null ? StockModel.fromDocumentSnapshot(result) : null;
  }

  @override
  Future<StockModel> getStockById({required String id}) async {
    var stockDoc = await stockCollection.doc(id).get();

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
        .get();
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
        .get();

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
        .get();

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
      throw FirebaseException(
          plugin: 'GET STOCK BY CODE ERROR',
          message: 'More then one document was found');
    }

    if (result.docs.length == 1) {
      return result.docs.first;
    }

    return null;
  }
}
