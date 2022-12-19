import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/core/widgets/show_entity_selection_dialog.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/provider.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../../provider/services/i_provider_service.dart';
import '../../errors/stock_error.dart';
import '../../services/i_stock_service.dart';

part 'stock_controller.g.dart';

class StockController = _StockControllerBase with _$StockController;

abstract class _StockControllerBase with Store {
  final IStockService stockService;
  final IStockUsecase stockUsecase;
  final IProductUsecase productUsecase;
  final IProviderService providerService;

  _StockControllerBase(this.stockUsecase, this.stockService,
      this.productUsecase, this.providerService);

  final dateFormat = DateFormat('dd-MM-yyyy');

  @observable
  String selectedDateString = '';
  @observable
  bool loading = false;
  @observable
  var providerList = ObservableList<Provider>.of([]);
  @observable
  var stockList = ObservableList<Stock>.of([]);
  @observable
  var selectedStockList = ObservableList<Stock>.of([]);
  @observable
  Provider? selectedProvider;
  @observable
  Option<StockError> error = none();
  @observable
  Option<Stock> success = none();

  List<Product> productList = [];

  late DateTime iniDate;
  late DateTime endDate;

  final stockDefaultLeftController = TextEditingController();

  @action
  initState({required List<Product> productList}) {
    this.productList = productList;

    resetDateToToday();

    setSelectedDateString();

    resetStockLeft();
  }

  @action
  showDateTimeRangeSelector(BuildContext context) async {
    await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: iniDate,
        end: endDate,
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((result) {
      if (result != null) {
        iniDate = result.start;
        endDate = result.end;

        setSelectedDateString();
      }
    });
  }

  @action
  setSelectedDateString() {
    selectedDateString =
        dateFormat.format(iniDate) + ' | ' + dateFormat.format(endDate);
  }

  @action
  resetDateToToday() {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    setSelectedDateString();
  }

  @action
  setSelectedProvider(Provider provider) {
    selectedProvider = provider;
  }

  @action
  getProviderListByStockBetweenDates() async {
    loading = true;
    selectedProvider = null;

    stockList.clear();
    providerList.clear();

    resetStockLeft();

    final providerResult =
        await stockUsecase.getProviderListByStockBetweenDates(iniDate, endDate);

    providerResult.fold((l) => error = optionOf(l), (r) {
      providerList = ObservableList.of(r);
      if (providerList.isNotEmpty) {
        providerService.sortProviderListByRegistrationDate(providerList);
        selectedProvider = providerList.first;
      }
    });

    loading = false;
  }

  @action
  showEntitySelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => ShowEntitySelectionDialog(
        entityList: productList,
      ),
    ).then((value) {
      if (value != null && value is Product) {
        createEmptyStock(value, true);
      }
    });
  }

  @action
  getStockListByProviderBetweenDates() async {
    if (selectedProvider != null) {
      loading = true;

      selectedStockList.clear();
      stockList.clear();

      final providerResult =
          await stockUsecase.getStockListByProviderBetweenDates(
              provider: selectedProvider!, iniDate: iniDate, endDate: endDate);

      providerResult.fold((l) => error = optionOf(l), (r) {
        stockService.sortStockListByProductName(r);
        stockList = ObservableList.of(r);
      });

      loading = false;
    }
  }

  @action
  getProviderDropdownItems(BuildContext context) {
    return providerList
        .map((provider) => DropdownMenuItem(
              child: Text(
                '${provider.name} - ${provider.location}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              value: provider,
            ))
        .toList();
  }

  @action
  addRemoveStockFromSelectedStockList(Stock stock) {
    selectedStockList.contains(stock)
        ? selectedStockList.remove(stock)
        : selectedStockList.add(stock);

    stockService.sortStockListByProductName(selectedStockList);
  }

  @action
  stockLeftSubmit(text) {
    int stockLeft = int.parse(text);

    for (var s in stockList) {
      s.totalOrdered = s.total + stockLeft;
      stockUsecase.updateStock(s);
    }

    ///modifying stockList to mobx reaction get the state
    reloadStockList();
  }

  @action
  reloadStockList() {
    final List<Stock> updatedList = stockList;
    stockList = ObservableList.of([]);
    stockList = ObservableList.of(updatedList);
  }

  @action
  createDuplicatedStock(
      Stock stock, Provider provider, bool movePropertiesAndDelete) async {
    if (stock.product.provider == provider) {
      return;
    }

    var newStock = StockModel.fromStock(stock);

    newStock.product.provider = provider;
    newStock.product.provider.name = provider.name;
    newStock.product.provider.id = provider.id;

    if (!movePropertiesAndDelete) {
      newStock.total = 0;
      newStock.totalOrdered = 0;
    }

    final createResult = await stockUsecase.createStock(newStock);

    createResult.fold(
      (l) => error = optionOf(l),
      (newStock) async {
        if (movePropertiesAndDelete) {
          final deleteResult = await stockUsecase.deleteStock(stock);

          deleteResult.fold((l) => error = optionOf(l), (r) => {});
        }

        reloadProviderListAndStockList(newStock.product.provider);
      },
    );
  }

  @action
  loadStockDefault() async {
    loading = true;

    final result =
        await productUsecase.getProductListByEnabledAndStockDefaultTrue();

    result.fold((l) => error = optionOf(StockError(l.message)),
        (productList) async {
      for (var p in productList) {
        createEmptyStock(p, false);
      }
    });

    await Future.delayed(const Duration(seconds: 1));

    await getProviderListByStockBetweenDates();
    loading = false;
  }

  @action
  createEmptyStock(Product product, bool reloadAfterCreate) async {
    final stock = StockModel(
        id: '0',
        registrationDate: DateTime.now(),
        total: 0,
        totalOrdered: 0,
        product: product);

    final createResult = await stockUsecase.createStock(stock);

    createResult.fold((l) => error = optionOf(l), (r) async {
      if (reloadAfterCreate) {
        await reloadProviderListAndStockList(r.product.provider);
      }
    });
  }

  @action
  reloadProviderListAndStockList(Provider provider) async {
    await getProviderListByStockBetweenDates();
    setSelectedProvider(provider);
    await getStockListByProviderBetweenDates();
  }

  @action
  resetStockLeft() {
    stockDefaultLeftController.text = '0';
  }

  @action
  removeStock(Stock stock) async {
    loading = true;
    final result = await stockUsecase.deleteStock(stock);

    result.fold((l) => error = optionOf(l), (r) {
      stockList.remove(stock);
    });

    loading = false;
  }
}
