import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/errors/stock_error.dart';
import 'package:get_storage/get_storage.dart';

import '../../../domain/models/product_model.dart';
import '../infra/datasources/i_new_stock_datasource.dart';
import 'helper/stock_firebase_helper.dart';

class NewStockFirebaseDatasourceImpl implements INewStockDatasource {
  final FirebaseFirestore firebase;
  final StockFirebaseHelper helper;

  late CollectionReference<Map<String, dynamic>> stockCollection;

  NewStockFirebaseDatasourceImpl(
      {required this.firebase, required this.helper, String? companyID}) {
    stockCollection = firebase
        .collection('company')
        .doc(companyID ?? GetStorage().read('companyID'))
        .collection('stock');
  }

  @override
  Future<StockModel> increaseTotalFromStock(
      {required ProductModel product,
      required DateTime date,
      required int increaseQuantity}) async {
    var stock = helper.getEmptyStock(
        product: product, date: date, total: increaseQuantity);

    final stockFromDB = await helper.getStockByCode(stock.code);

    if (stockFromDB != null) {
      stockFromDB.total += increaseQuantity;

      return await helper.updateStock(stockFromDB);
    } else {
      return await helper.createNewStock(stock);
    }
  }

  @override
  Future<StockModel> decreaseTotalFromStock(
      {required ProductModel product,
      required DateTime date,
      required int decreaseQuantity,
      bool deleteIfEmpty = false}) async {
    var stock = helper.getEmptyStock(product: product, date: date);

    final stockFromDB = await helper.getStockByCode(stock.code);

    if (stockFromDB == null) {
      throw StockError('Stock não encontrado - CODE ${stock.code}');
    }

    stockFromDB.total -= decreaseQuantity;

    return stockFromDB.total == 0 && stockFromDB.totalOrdered == 0
        ? await helper.deleteStock(stockFromDB)
        : await helper.updateStock(stockFromDB);
  }
}
