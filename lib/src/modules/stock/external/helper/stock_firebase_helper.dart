import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../domain/models/product_model.dart';
import '../../../../domain/models/stock_model.dart';
import '../../errors/stock_error.dart';

class StockFirebaseHelper {
  late final CollectionReference stockCollection;
  final FirebaseFirestore firebase;

  StockFirebaseHelper({required this.firebase, String? companyID}){
    stockCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('stock');
  }

  Future<StockModel> createNewStock(
      {required StockModel stock, String? stockID}) async {
    String newID = '';

    stockID != null
        ? await stockCollection.doc(stockID).set(stock.toMap()).catchError(
            (e) => throw FirebaseException(
                plugin: 'CREATE STOCK ERROR', message: e.toString()))
        : await stockCollection
            .add(stock.toMap())
            .catchError((e) => throw FirebaseException(
                plugin: 'CREATE STOCK ERROR', message: e.toString()))
            .then((value) => newID = value.id);

    StockModel? createdStock = await getStockByCode(stock.code);

    if (createdStock == null) {
      throw StockError('Stock não encontrado - CODE: ${stock.code}');
    }

    if (stockID != null) {
      return createdStock;
    }

    createdStock.id = newID;

    return await updateStock(createdStock);
  }

  Future<StockModel> updateStock(StockModel stock) async {
    await stockCollection.doc(stock.id).update(stock.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'UPDATE STOCK ERROR', message: e.toString()));

    return stock;
  }

  StockModel getEmptyStock({
    required ProductModel product,
    required DateTime date,
    int total = 0,
    int totalOrdered = 0,
  }) {
    StockModel stock = StockModel(
        id: '0',
        code: '0',
        total: total,
        totalOrdered: totalOrdered,
        registrationDate: date,
        product: product);

    setStockCode(stock);

    return stock;
  }

  void setStockCode(StockModel stock) {
    stock.code = stock.product.id +
        stock.product.provider.id +
        DateTime(stock.registrationDate.year, stock.registrationDate.month,
                stock.registrationDate.day)
            .toString();
  }

  Future<StockModel?> getStockByCode(String code) async {
    final result = await getDocumentReferenceByCode(code);

    return result != null ? StockModel.fromDocumentSnapshot(result) : null;
  }

  Future<StockModel> getStockById(String id) async {
    var stockDoc = await stockCollection.doc(id).get();

    if (stockDoc.exists) {
      return StockModel.fromDocumentSnapshot(stockDoc);
    }

    throw StockError('Stock ID - $id não encontrado');
  }

  Future<QueryDocumentSnapshot?> getDocumentReferenceByCode(String code) async {
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

  mergeStockList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapStockList,
      List<StockModel> stockList) {
    for (var s in snapStockList) {
      var newStock = StockModel.fromMap(s.data());

      if (stockList.contains(newStock)) {
        var stockFromList = stockList.singleWhere(
            (stockFromList) => stockFromList.product == newStock.product);

        stockFromList.total += newStock.total;
        stockFromList.totalOrdered += newStock.totalOrdered;
      } else {
        stockList.add(newStock);
      }
    }
  }
}
