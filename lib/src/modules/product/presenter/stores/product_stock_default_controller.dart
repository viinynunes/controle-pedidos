import 'package:controle_pedidos/src/domain/entities/product.dart';
import 'package:controle_pedidos/src/modules/product/domain/usecases/i_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/provider.dart';
import '../../../provider/domain/usecases/I_provider_usecase.dart';
import '../../errors/product_error.dart';

part 'product_stock_default_controller.g.dart';

class ProductStockDefaultController = _ProductStockDefaultControllerBase
    with _$ProductStockDefaultController;

abstract class _ProductStockDefaultControllerBase with Store {
  final IProductUsecase productUsecase;
  final IProviderUsecase providerUsecase;

  _ProductStockDefaultControllerBase(this.productUsecase, this.providerUsecase);

  @observable
  bool loading = false;
  @observable
  bool searching = false;
  @observable
  String searchText = '';
  @observable
  var productList = ObservableList<Product>.of([]);
  @observable
  var productFilteredList = ObservableList<Product>.of([]);
  @observable
  var providerList = ObservableList<Provider>.of([]);
  @observable
  Option<ProductError> error = none();
  @observable
  Provider? selectedProvider;

  @action
  initState() async {
    loading = true;
    await getProviderList();
    loading = false;
  }

  @action
  getProviderList() async {
    final result = await providerUsecase.getProviderListByEnabled();

    result.fold((l) => error = optionOf(ProductError(l.message)), (r) {
      providerList = ObservableList.of(r);
    });
  }

  @action
  setSelectedProvider(Provider provider) {
    selectedProvider = provider;
  }

  @action
  getProductListByProvider() async {
    if (selectedProvider == null) {
      return;
    }

    loading = true;

    final result = await productUsecase
        .getEnabledProductListByProvider(selectedProvider?.id ?? '');

    result.fold(
        (l) => error = optionOf(l), (r) => productList = ObservableList.of(r));

    loading = false;
  }

  @action
  toggleCheckbox(Product product) {
    product.stockDefault = !product.stockDefault;
  }

  @action
  updateProduct(Product product) async {
    final updateResult = await productUsecase.updateProduct(product);

    updateResult.fold((l) => error = optionOf(l), (r) => reloadProductList());
  }

  @action
  reloadProductList() {
    final auxList = productList;
    productList = ObservableList.of([]);
    productList = ObservableList.of(auxList);
  }
}
