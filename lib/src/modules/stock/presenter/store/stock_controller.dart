import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/provider.dart';
import '../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../errors/stock_error.dart';
import '../../services/i_stock_service.dart';

part 'stock_controller.g.dart';

class StockController = _StockControllerBase with _$StockController;

abstract class _StockControllerBase with Store {
  final IStockService stockService;
  final IStockUsecase stockUsecase;
  final IProductUsecase productUsecase;

  _StockControllerBase(
      this.stockUsecase, this.productUsecase, this.stockService);

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
  Provider? selectedProvider;
  @observable
  Option<StockError> error = none();
  @observable
  Option<Stock> success = none();

  late DateTime iniDate;
  late DateTime endDate;

  final stockDefaultLeftController = TextEditingController();

  @action
  initState() {
    iniDate = DateTime.now();
    endDate = DateTime.now();

    setSelectedDateString();

    stockDefaultLeftController.text = '0';
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
  setSelectedProvider(Provider provider) {
    selectedProvider = provider;
  }

  @action
  getProviderListByStockBetweenDates() async {
    loading = true;

    final providerResult =
        await stockUsecase.getProviderListByStockBetweenDates(iniDate, endDate);

    providerResult.fold((l) => error = optionOf(l), (r) {
      providerList = ObservableList.of(r);
      selectedProvider = providerList.first;
    });

    loading = false;
  }

  @action
  getStockListByProviderBetweenDates() async {
    if (selectedProvider != null) {
      loading = true;

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
  stockLeftSubmit(text) {
    int stockLeft = int.parse(text);

    for (var s in stockList) {
      s.totalOrdered = s.total + stockLeft;
    }

    //modifying stockList to mobx reaction get the state
    final List<Stock> updatedList = stockList;
    stockList = ObservableList.of([]);

    reloadStockList(updatedList);
  }

  @action
  reloadStockList(List<Stock> updatedList) {
    stockList = ObservableList.of(updatedList);
  }

  @action
  callEntitySelection(BuildContext context) async {
    List<Product> productList = [];

    final productResult = await productUsecase.getProductListByEnabled();

    productResult.fold(
        (l) => error = optionOf(StockError(l.message)), (r) => productList = r);

    await showDialog(
      context: context,
      builder: (_) => ShowEntitySelectionDialog(
        entityList: productList,
      ),
    ).then((value) {
      if (value != null && value is Product) {
        createEmptyStock(value);
      }
    });
  }

  @action
  createEmptyStock(Product product) async {
    final stock = StockModel(
        id: '0',
        registrationDate: DateTime.now(),
        total: 0,
        totalOrdered: 0,
        product: product);

    final createResult = await stockUsecase.createStock(stock);

    createResult.fold((l) => error = optionOf(l), (r) {
      setSelectedProvider(r.product.provider!);

      getStockListByProviderBetweenDates();
    });
  }
}
