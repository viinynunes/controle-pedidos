import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';

import '../../firebase_helper_impl.dart';
import '../infra/datasources/i_stock_datasource.dart';

class StockFirebaseDatasourceImpl implements IStockDatasource {
  final firebase = FirebaseHelperImpl();

  @override
  Future<StockModel> createStock(StockModel stock) async {
    _setStockDate(stock);
    _setStockId(stock);

    final alreadyInStockSnap = await _getStockFromFirebase(stock);

    if (alreadyInStockSnap == null) {
      await firebase.getStockCollection().add(stock.toMap()).catchError((e) =>
          throw FirebaseException(
              plugin: 'CREATE STOCK ERROR', message: e.toString()));

      return stock;
    }

    if (alreadyInStockSnap.docs.length == 1) {
      var newStock = StockModel.fromMap(alreadyInStockSnap.docs.first.data());
      newStock.total += stock.total;

      return updateStock(newStock);
    }

    throw FirebaseException(
        plugin: 'CREATE STOCK ERROR', message: 'UNEXPECTED ERROR');
  }

  @override
  Future<StockModel> createDuplicatedStock(StockModel stock) {
    // TODO: implement createDuplicatedStock
    throw UnimplementedError();
  }

  @override
  Future<StockModel> updateStockDate(
      StockModel toDeleteStock, StockModel updatedStock) async {
    _setStockId(updatedStock);

    final snap = await _getStockFromFirebase(updatedStock);

    if (snap == null) {
      await createStock(updatedStock);
      await deleteStock(toDeleteStock);
      return updatedStock;
    }

    var stockOnDB = StockModel.fromMap(snap.docs.first.data());

    stockOnDB.total += updatedStock.total;
    stockOnDB.totalOrdered += updatedStock.totalOrdered;

    await updateStock(stockOnDB);
    await deleteStock(toDeleteStock);

    return stockOnDB;
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    final snap = await _getStockFromFirebase(stock);

    if (snap == null) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'NENHUM ITEM ENCONTRADO');
    }

    await firebase
        .getStockCollection()
        .doc(snap.docs.first.id)
        .update(stock.toMap());

    return stock;
  }

  @override
  Future<StockModel> updateStockByEndDate(
      StockModel stock, DateTime endDate, bool increase) async {
    stock.registrationDate = endDate;
    _setStockDate(stock);
    _setStockId(stock);

    return increase
        ? await increaseStock(stock)
        : await decreaseStock(stock, false);
  }

  @override
  Future<StockModel> increaseStock(StockModel stock) async {
    final snap = await _getStockFromFirebase(stock);

    if (snap == null) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'NENHUM ITEM ENCONTRADO');
    }

    var newStock = StockModel.fromMap(snap.docs.first.data());

    newStock.totalOrdered++;

    return await updateStock(newStock);
  }

  @override
  Future<StockModel> decreaseStock(StockModel stock, bool fromOrder) async {
    _setStockDate(stock);
    _setStockId(stock);
    final snap = await _getStockFromFirebase(stock);

    if (snap == null) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'NENHUM ITEM ENCONTRADO');
    }

    var newStock = StockModel.fromMap(snap.docs.first.data());

    fromOrder ? newStock.total -= stock.total : newStock.totalOrdered--;

    if (newStock.total == 0 && newStock.totalOrdered == 0) {
      await deleteStock(stock);
    } else {
      return await updateStock(newStock);
    }

    return stock;
  }

  @override
  Future<bool> deleteStock(StockModel stock) async {
    final stockFromFB = await _getStockFromFirebase(stock);

    if (stockFromFB == null) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'NENHUM ITEM ENCONTRADO');
    }

    await firebase
        .getStockCollection()
        .doc(stockFromFB.docs.first.id)
        .delete()
        .catchError((e) => throw FirebaseException(
            plugin: 'DELETE STOCK ERROR', message: 'STOCK NOT FOUND'));

    return true;
  }

  @override
  Future<Set<ProviderModel>> getProviderListByStockBetweenDates(
      DateTime iniDate, DateTime endDate) async {
    Set<ProviderModel> providerList = {};

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snapStock = await firebase
        .getStockCollection()
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
    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    List<StockModel> stockList = [];

    final snap = await firebase
        .getStockCollection()
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .get();

    _mergeStockList(snap.docs, stockList);

    return stockList;
  }

  @override
  Future<List<StockModel>> getStockListByProviderBetweenDates(
      {required ProviderModel provider,
      required DateTime iniDate,
      required DateTime endDate}) async {
    List<StockModel> stockList = [];

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final snap = await firebase
        .getStockCollection()
        .where('registrationDate', isGreaterThanOrEqualTo: iniDate)
        .where('registrationDate', isLessThanOrEqualTo: endDate)
        .where('product.provider.id', isEqualTo: provider.id)
        .get();

    _mergeStockList(snap.docs, stockList);

    return stockList;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> _getStockFromFirebase(
      Stock stock) async {
    final stockToUpdate = await firebase
        .getStockCollection()
        .where('id', isEqualTo: stock.id)
        .where('registrationDate', isEqualTo: stock.registrationDate)
        .get()
        .catchError((e) => throw FirebaseException(
            plugin: 'GET STOCK FROM FIREBASE ERROR', message: e.toString()));

    if (stockToUpdate.docs.length > 1) {
      throw FirebaseException(
          plugin: 'GET STOCK ERROR', message: 'MAIS DE 1 ITEM ENCONTRADO');
    }

    if (stockToUpdate.docs.isEmpty) {
      return null;
    }

    return stockToUpdate;
  }

  void _setStockId(StockModel stock) {
    stock.id = stock.product.id +
        stock.product.provider.id +
        DateTime(stock.registrationDate.year, stock.registrationDate.month,
                stock.registrationDate.day)
            .toString();
  }

  void _setStockDate(StockModel stock) {
    stock.registrationDate = DateTime(stock.registrationDate.year,
        stock.registrationDate.month, stock.registrationDate.day);
  }

  _mergeStockList(
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
