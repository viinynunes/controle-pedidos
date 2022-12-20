import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:controle_pedidos/src/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/domain/usecases/i_provider_usecase.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../provider/services/i_provider_service.dart';
import '../../errors/product_error.dart';
import '../../../../domain/models/product_model.dart';

part 'product_registration_controller.g.dart';

class ProductRegistrationController = _ProductRegistrationControllerBase
    with _$ProductRegistrationController;

abstract class _ProductRegistrationControllerBase with Store {
  final IProductUsecase productUsecase;
  final IProviderUsecase providerUsecase;
  final IProviderService providerService;

  _ProductRegistrationControllerBase(
      this.productUsecase, this.providerUsecase, this.providerService);

  @observable
  bool loading = false;
  @observable
  bool newProduct = true;
  @observable
  bool enabled = true;
  @observable
  Option<ProductError> error = none();
  @observable
  Option<Product> success = none();
  @observable
  var providerList = ObservableList<Provider>.of([]);
  @observable
  Provider? selectedProvider;

  late ProductModel newProductData;

  final nameController = TextEditingController();
  final categoryController = TextEditingController();

  final nameFocus = FocusNode();
  final providerSelectionFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @action
  initState(Product? product) async {
    if (product != null) {
      newProduct = false;
      newProductData = ProductModel.fromProduct(product: product);
      nameController.text = newProductData.name;
      categoryController.text = newProductData.category;
      enabled = newProductData.enabled;
    }

    nameFocus.requestFocus();

    await getProviderListByEnabled();
    await getProviderFromProduct();
  }

  @action
  getProviderListByEnabled() async {
    loading = true;

    final result = await providerUsecase.getProviderListByEnabled();

    result.fold((l) => error = optionOf(ProductError(l.message)), (r) {
      providerService.sortProviderListByRegistrationDate(r);
      providerList = ObservableList.of(r);
    });

    loading = false;
  }

  @action
  getProviderFromProduct() async {
    if (!newProduct) {
      loading = true;

      final result =
          await providerUsecase.getProviderById(newProductData.provider.id);

      result.fold((l) => error = optionOf(ProductError(l.message)),
          (r) => selectedProvider = r);

      loading = false;
    } else {
      selectedProvider = providerList.first;
    }
  }

  @action
  changeEnabled() {
    enabled = !enabled;
  }

  @action
  selectProvider(Provider provider) {
    selectedProvider = ProviderModel.fromProvider(provider);
  }

  clearFields() {
    nameController.text = '';
    categoryController.text = '';
  }

  String? nameValidator(String? text) {
    if (text!.isEmpty) {
      return 'Campo Obrigatório';
    }

    return null;
  }

  String? categoryValidator(String? text) {
    if (text!.isEmpty || text.length > 3) {
      return 'Campo Obrigatório';
    }

    return null;
  }

  @action
  saveOrUpdate(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      loading = true;
      initNewProduct();
      if (newProduct) {
        final create = await productUsecase.createProduct(newProductData);

        create.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      } else {
        final update = await productUsecase.updateProduct(newProductData);

        update.fold((l) => error = optionOf(l), (r) {
          success = optionOf(r);
          Navigator.of(context).pop(r);
        });
      }
    }
  }

  initNewProduct() {
    if (selectedProvider != null) {
      newProductData = ProductModel(
          id: newProduct ? '0' : newProductData.id,
          name: nameController.text,
          category: categoryController.text,
          enabled: enabled,
          stockDefault: false,
          provider: selectedProvider!);
    }
  }
}
