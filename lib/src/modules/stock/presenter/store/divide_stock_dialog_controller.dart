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

  changeStockProvider(
      {required String stockID, required Provider newProvider}) async {
    await changeStockProviderUsecase(
        stockID: stockID, newProvider: newProvider);
  }

  @action
  createDuplicatedStock(
      Stock stock, Provider provider, bool movePropertiesAndDelete) async {
/*    if (stock.product.provider == provider) {
      return;
    }

    var newStock = StockModel.fromStock(stock);

    newStock.product.provider = provider;

    if (!movePropertiesAndDelete) {
      newStock.total = 0;
      newStock.totalOrdered = 0;
    }

    final createResult = await createStockUsecase(newStock);

    createResult.fold(
          (l) => error = optionOf(l),
          (newStock) async {
        if (movePropertiesAndDelete) {
          final deleteResult = await deleteStockUsecase(stock);

          deleteResult.fold((l) => error = optionOf(l), (r) => {});
        }

        reloadProviderListAndStockList(newStock.product.provider);
      },
    );*/
  }
}
