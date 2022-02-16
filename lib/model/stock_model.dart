import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:scoped_model/scoped_model.dart';

class StockModel extends Model {
  final firebaseCollection = FirebaseFirestore.instance.collection('stock');
  bool loading = false;

  Future<StockData> createStockItem(StockData newStock) async {
    bool alreadyInStock = false;

    newStock.creationDate = DateTime(newStock.creationDate.year,
        newStock.creationDate.month, newStock.creationDate.day);

    final snap = await firebaseCollection
        .where('creationDate', isEqualTo: newStock.creationDate)
        .get();

    if (snap.docs.isNotEmpty) {
      for (var e in snap.docs) {
        alreadyInStock = false;
        var stockIndex = StockData.fromMap(e.id, e.data());

        if (stockIndex.product.id == newStock.product.id) {
          stockIndex.total += newStock.total;
          await firebaseCollection
              .doc(stockIndex.id)
              .update(stockIndex.toMap());
          alreadyInStock = true;
          break;
        }
      }
      if (alreadyInStock == false) {
        final recStock = await firebaseCollection.add(newStock.toMap());
        newStock.id = recStock.id;
      }
    } else {
      final recStock = await firebaseCollection.add(newStock.toMap());
      newStock.id = recStock.id;
    }

    return newStock;
  }
}
