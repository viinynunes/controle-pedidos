import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/firebase_helper.dart';

import '../infra/datasources/i_stock_datasource.dart';

class StockFirebaseDatasourceImpl implements IStockDatasource {
  final _stockCollection =
      FirebaseHelper.firebaseCollection.collection('stock');

  @override
  Future<StockModel> createStock(StockModel stock) async {
    _setStockDate(stock);
    _setStockId(stock);

    final alreadyInStockSnap = await _stockCollection.doc(stock.id).get();

    late StockModel newStock;

    if (alreadyInStockSnap.data() != null) {
      newStock = StockModel.fromMap(alreadyInStockSnap.data()!);
      newStock.total += stock.total;
    } else {
      newStock = StockModel.fromStock(stock);
    }

    stock.product.provider ??= await _getProvider(stock.product.providerId);

    _stockCollection.doc(stock.id).set(newStock.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'CREATE STOCK ERROR', message: e.toString()));

    return stock;
  }

  @override
  Future<StockModel> createDuplicatedStock(StockModel stock) {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    await _stockCollection.doc(stock.id).update(stock.toMap()).catchError((e) =>
        throw FirebaseException(
            plugin: 'UPDATE STOCK ERROR', message: e.toString()));

    return stock;
  }

  _getStockFromFirebase(Stock stock) async {
    final stockToUpdate = await _stockCollection.doc(stock.id).get().catchError(
        (e) => throw FirebaseException(
            plugin: 'GET STOCK ERROR', message: e.toString()));

    if (stockToUpdate.data() == null) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'STOCK NOT FOUND');
    }

    return StockModel.fromMap(stockToUpdate.data()!);
  }

  @override
  Future<StockModel> increaseStock(StockModel stock) async {
    _setStockDate(stock);
    _setStockId(stock);
    var newStock = await _getStockFromFirebase(stock);

    newStock.total += stock.total;

    return await updateStock(newStock);
  }

  @override
  Future<StockModel> decreaseStock(StockModel stock) async {
    _setStockDate(stock);
    _setStockId(stock);
    var newStock = await _getStockFromFirebase(stock);

    newStock.total -= stock.total;

    if (newStock.total == 0 && newStock.totalOrdered == 0) {
      await deleteStock(stock);
    } else {
      return await updateStock(newStock);
    }

    return stock;
  }

  @override
  Future<bool> deleteStock(StockModel stock) async {
    await _stockCollection.doc(stock.id).delete().catchError((e) =>
        throw FirebaseException(
            plugin: 'DECREASE STOCK ERROR', message: 'STOCK NOT FOUND'));

    return true;
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
      required DateTime endDate}) async {
    List<StockModel> stockList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snap = await _stockCollection
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .where('product.provider.id', isEqualTo: provider.id)
        //.orderBy('stock.product.name')
        .get();

    for (var s in snap.docs) {
      stockList.add(StockModel.fromMap(s.data()));
    }

    return stockList;
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

  void _setStockId(StockModel stock) {
    stock.id = stock.product.id +
        stock.product.providerId +
        stock.registrationDate.toString();
  }

  void _setStockDate(StockModel stock) {
    stock.registrationDate = DateTime(stock.registrationDate.year,
        stock.registrationDate.month, stock.registrationDate.day);
  }
}
