import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/pages/product/product_registration_page.dart';
import 'package:flutter/material.dart';

import '../data/product_data.dart';

class ProductService {
  Future<ProductData?> createOrUpdate(
      {ProductData? product,
      required List<ProductData> productList,
      required BuildContext context}) async {
    var recProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductRegistrationPage(
          product: product,
        ),
      ),
    );

    if (recProduct != null) {
      if (product != null) {
        ProductModel.of(context).updateProduct(recProduct);
        productList.remove(product);
      } else {
        recProduct = await ProductModel.of(context).createProduct(recProduct);
      }
      productList.add(recProduct);
    }

    return recProduct;
  }

  void sortProductsByName(List<ProductData> productList) {
    productList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
