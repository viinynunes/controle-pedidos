import 'package:controle_pedidos/src/modules/provider/domain/usecases/I_provider_usecase.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';

part 'divide_stock_dialog_controller.g.dart';

class DivideStockDialogController = _DivideStockDialogControllerBase
    with _$DivideStockDialogController;

abstract class _DivideStockDialogControllerBase with Store {
  final IProviderUsecase providerUsecase;

  _DivideStockDialogControllerBase(this.providerUsecase);

  @observable
  Stock? stock;
  @observable
  Provider? selectedProvider;
  @observable
  bool loading = false;
  @observable
  bool movePropertiesAndDelete = false;
  @observable
  var providerList = ObservableList<Provider>.of([]);

  @action
  initState(Stock stock) async {
    this.stock = stock;
    selectedProvider = stock.product.provider;
    await getProviderListByEnabled();
  }

  @action
  setSelectedProvider(Provider provider) {
    selectedProvider = provider;
  }

  @action
  toggleMovePropertiesAndDelete() {
    movePropertiesAndDelete = !movePropertiesAndDelete;
  }

  @action
  getProviderListByEnabled() async {
    loading = true;

    final result = await providerUsecase.getProviderListByEnabled();

    result.fold((l) {}, (r) => providerList = ObservableList.of(r));

    loading = false;
  }
}
