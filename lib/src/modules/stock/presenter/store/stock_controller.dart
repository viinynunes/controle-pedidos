import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/admob/services/ad_service.dart';
import '../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/stock.dart';
import '../../../product/domain/usecases/i_product_usecase.dart';
import '../../../provider/services/i_provider_service.dart';
import '../../domain/usecases/delete_stock_usecase.dart';
import '../../domain/usecases/get_stock_lists_usecase.dart';
import '../../domain/usecases/increase_stock_total_usecase.dart';
import '../../domain/usecases/update_stock_usecase.dart';
import '../../errors/stock_error.dart';
import '../../services/i_stock_service.dart';

part 'stock_controller.g.dart';

class StockController = _StockControllerBase with _$StockController;

abstract class _StockControllerBase with Store {
  final IStockService stockService;
  final IProductUsecase productUsecase;
  final IProviderService providerService;
  final GetStockListsUsecase getStockListsUsecase;
  final UpdateStockUsecase updateStockUsecase;
  final DeleteStockUsecase deleteStockUsecase;
  final IncreaseStockTotalUsecase increaseStockTotalUsecase;
  final AdService adService;

  _StockControllerBase(
      this.stockService,
      this.productUsecase,
      this.providerService,
      this.getStockListsUsecase,
      this.updateStockUsecase,
      this.deleteStockUsecase,
      this.increaseStockTotalUsecase, this.adService);

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
  initState() async {
    resetDateToToday();

    await getProductList();

    resetStockLeft();
  }

  @action
  getProductList() async {
    loading = true;

    final result = await productUsecase.getProductListByEnabled();

    result.fold((l) => error = optionOf(StockError(l.message)),
        (r) => productList = ObservableList.of(r));

    loading = false;
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

    final providerResult = await getStockListsUsecase
        .getProviderListByStockBetweenDates(iniDate: iniDate, endDate: endDate);

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
          await getStockListsUsecase.getStockListByProviderBetweenDates(
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
                style: Theme.of(context).textTheme.bodyMedium,
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
      updateStockUsecase(s);
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
    final createResult = await increaseStockTotalUsecase(
        increaseQuantity: 0, product: product, date: DateTime.now());

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
    final result = await deleteStockUsecase(stock);

    result.fold((l) => error = optionOf(l), (r) {
      stockList.remove(stock);
    });

    loading = false;
  }

  bool loadAd(){
    return adService.loadAd();
  }
}
