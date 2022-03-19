import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/model/order_model.dart';
import 'package:flutter/cupertino.dart';
import '../data/order_data.dart';

class TransactionsService {

  Future<List<OrderData>> getTransactionsByProduct(ProductData product, BuildContext context) async {
    final list = await OrderModel.of(context).getOrderListByProduct(product);

    return list;
  }
}