import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:controle_pedidos/src/modules/product/presenter/pages/i_product_registration_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../errors/product_error.dart';

part 'product_controller.g.dart';

class ProductController = _ProductControllerBase with _$ProductController;

abstract class _ProductControllerBase with Store {
  final IProductUsecase productUsecase;

  _ProductControllerBase(this.productUsecase);

  @observable
  String searchText = '';
  @observable
  bool searching = false;
  @observable
  bool loading = false;
  @observable
  Option<ProductError> error = none();
  @observable
  var productList = ObservableList<Product>.of([]);
  @observable
  var filteredProductList = ObservableList<Product>.of([]);

  final searchFocus = FocusNode();

  @action
  initState() async {
    await getProductList();
  }

  @action
  getProductList() async {
    loading = true;

    final result = await productUsecase.getProductList();

    result.fold(
        (l) => error = optionOf(l), (r) => productList = ObservableList.of(r));
    loading = false;
  }

  @action
  filterProductListByText() {
    searchText.toLowerCase();
    filteredProductList.clear();

    List<Product> auxList = [];

    for (var p in productList) {
      if (p.name.toLowerCase().contains(searchText) ||
          p.category.toLowerCase().contains(searchText) ||
          p.providerName.toLowerCase().contains(searchText)) {
        auxList.add(p);
      }
    }

    filteredProductList = ObservableList.of(auxList);
  }

  @action
  callProductRegistrationPage(
      {required BuildContext context,
      required IProductRegistrationPage registrationPage}) async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => registrationPage));

    if (result != null) {
      initState();
    }
  }
}
