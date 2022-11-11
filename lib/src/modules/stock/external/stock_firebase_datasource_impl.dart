import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';

import '../infra/datasources/i_stock_datasource.dart';

class StockFirebaseDatasourceImpl implements IStockDatasource {
  final _stockCollection =
      FirebaseHelper.firebaseCollection.collection('stock');

  @override
  Future<StockModel> createStock(StockModel stock) async {
    stock.registrationDate = DateTime(stock.registrationDate.year,
        stock.registrationDate.month, stock.registrationDate.day);

    final alreadyExistsSnap = await _stockCollection
        .where('registrationDate', isEqualTo: stock.registrationDate)
        .where('product.id', isEqualTo: stock.product.id)
        .where('product.providerId', isEqualTo: stock.product.providerId)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'CREATE STOCK ERROR - GET STOCK LIST BY DAY',
            message: e.toString()));

    if (alreadyExistsSnap.docs.isEmpty) {
      stock.product.provider = await _getProvider(stock.product.providerId);

      final result = await _stockCollection.add({}).catchError((e) =>
          throw FirebaseException(
              plugin: 'CREATE STOCK ERROR', message: e.toString()));

      stock.id = result.id;

      _stockCollection.doc(stock.id).update(stock.toMap()).catchError((e) =>
          throw FirebaseException(
              plugin: 'CREATE STOCK ERROR', message: e.toString()));

      return stock;
    }

    throw FirebaseException(
        plugin: 'CREATE STOCK ERROR', message: 'Produto já esta no estoque');
  }

  @override
  Future<StockModel> createDuplicatedStock(StockModel stock) {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> increaseStock(StockModel stock) {
    // TODO: implement increaseStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> decreaseStock(StockModel stock) {
    // TODO: implement decreaseStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> updateStock(StockModel stock) {
    // TODO: implement updateStock
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteStock() {
    // TODO: implement deleteStock
    throw UnimplementedError();
  }

  @override
  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    Set<ProviderModel> providerList = {};

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snapStock = await _stockCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .get();

    for (var s in snapStock.docs) {
      String providerId = s.get('product.providerId');

      if (!providerList.any((element) => element.id == providerId)) {
        providerList.add(await _getProvider(providerId));
      }
    }

    return providerList;
  }

  @override
  Future<List<StockModel>> getStockListBetweenDates(
      {required DateTime iniDate, required DateTime endDate}) {
    // TODO: implement getStockListBetweenDates
    throw UnimplementedError();
  }

  @override
  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate}) {
    // TODO: implement getStockListByProviderBetweenDates
    throw UnimplementedError();
  }

  _getProvider(String providerId) async {
    final providerSnap = await FirebaseHelper.firebaseCollection
        .collection('provider')
        .doc(providerId)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET STOCK PROVIDER ERROR', message: e.toString()));

    if (providerSnap.data() != null) {
      return ProviderModel.fromMap(map: providerSnap.data()!);
    } else {
      throw FirebaseException(
          plugin: 'GET STOCK PROVIDER ERROR',
          message: 'Fornecedor não encontrado');
    }
  }
}
