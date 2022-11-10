import 'package:controle_pedidos/src/domain/entities/stock.dart';
import 'package:controle_pedidos/src/domain/models/provider_model.dart';
import 'package:controle_pedidos/src/domain/models/stock_model.dart';
import 'package:controle_pedidos/src/modules/stock/domain/usecases/i_stock_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../domain/entities/provider.dart';
import '../../../../domain/models/product_model.dart';
import '../../errors/stock_error.dart';

part 'stock_controller.g.dart';

class StockController = _StockControllerBase with _$StockController;

abstract class _StockControllerBase with Store {
  final IStockUsecase stockUsecase;

  _StockControllerBase(this.stockUsecase);

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

    selectedProvider = null;
    stockList.clear();

    providerList = ObservableList.of([
      ProviderModel(
          id: '0',
          name: 'Nunes',
          location: 'Box E11',
          registrationDate: DateTime.now(),
          enabled: true,
          establishmentId: '0',
          establishmentName: 'Veiling'),
      ProviderModel(
          id: '1',
          name: 'Vinicius',
          location: 'Box E16',
          registrationDate: DateTime.now(),
          enabled: true,
          establishmentId: '1',
          establishmentName: 'Ceaflor'),
    ]);

    loading = false;

    /*loading = true;

    final providerResult =
        await stockUsecase.getProviderListByStockBetweenDates(iniDate, endDate);

    providerResult.fold((l) => error = optionOf(l), (r) {
      providerList = ObservableList.of(r);
      selectedProvider = providerList.first;
    });

    loading = false;*/
  }

  @action
  getStockListByProviderBetweenDates() async {
    final product = ProductModel(
        id: '0',
        category: 'vs',
        enabled: true,
        name: 'raphis p/17',
        stockDefault: false,
        providerId: '0',
        providerName: 'Nunes');

    stockList = ObservableList.of([
      StockModel(
          id: '3',
          total: 9,
          totalOrdered: 0,
          registrationDate: DateTime.now(),
          product: product),
      StockModel(
          id: '0',
          total: 2,
          totalOrdered: 0,
          registrationDate: DateTime.now(),
          product: product),
      StockModel(
          id: '1',
          total: 4,
          totalOrdered: 0,
          registrationDate: DateTime.now(),
          product: product),
      StockModel(
          id: '2',
          total: 14,
          totalOrdered: 0,
          registrationDate: DateTime.now(),
          product: product),
    ]);

/*    if (selectedProvider != null) {
      loading = true;

      stockList.clear();

      final providerResult =
          await stockUsecase.getStockListByProviderBetweenDates(
              provider: selectedProvider!, iniDate: iniDate, endDate: endDate);

      providerResult.fold(
          (l) => error = optionOf(l), (r) => stockList = ObservableList.of(r));

      loading = false;
    }*/
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
}
