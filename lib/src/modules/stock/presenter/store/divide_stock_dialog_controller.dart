import 'package:controle_pedidos/src/modules/provider/domain/usecases/i_provider_usecase.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../domain/usecases/change_stock_provider_usecase.dart';

part 'divide_stock_dialog_controller.g.dart';

class DivideStockDialogController = _DivideStockDialogControllerBase
    with _$DivideStockDialogController;

abstract class _DivideStockDialogControllerBase with Store {
  final IProviderUsecase providerUsecase;
  final ChangeStockProviderUsecase changeStockProviderUsecase;

  _DivideStockDialogControllerBase(
      this.providerUsecase, this.changeStockProviderUsecase);

  @observable
  Stock? stock;
  @observable
  Provider? selectedProvider;
  @observable
  bool loading = false;
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
  getProviderListByEnabled() async {
    loading = true;

    final result = await providerUsecase.getProviderListByEnabled();

    result.fold((l) {}, (r) => providerList = ObservableList.of(r));

    loading = false;
  }

  @action
  moveStockWithProperties(
      {required String stockID, required Provider newProvider}) async {
    await changeStockProviderUsecase.moveStockWithProperties(
        stockID: stockID, newProvider: newProvider);
  }

  @action
  duplicateStockWithoutProperties(
      {required String stockID, required Provider newProvider}) async {
    await changeStockProviderUsecase.duplicateStockWithoutProperties(
        stockID: stockID, newProvider: newProvider);
  }
}
