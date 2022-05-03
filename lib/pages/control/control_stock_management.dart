import 'package:controle_pedidos/pages/control/share_stock_Items_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/product_data.dart';
import '../../data/provider_data.dart';
import '../../data/stock_data.dart';
import '../../model/product_model.dart';
import '../../model/provider_model.dart';
import '../../model/stock_model.dart';
import '../../services/control_service.dart';
import '../../services/product_service.dart';
import '../../services/provider_service.dart';
import '../../utils/custom_colors.dart';
import '../../utils/enum_control_home_page.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/tiles/stock_list_tile.dart';
import '../product/show_product_list_dialog.dart';
import '../provider/show_provider_dialog.dart';
import '../stockDefault/stock_default_list.dart';
import '../transactions/transactions_dialog.dart';

class ControlStockManagement extends StatefulWidget {
  const ControlStockManagement({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<ControlStockManagement> createState() => _ControlStockManagementState();
}

class _ControlStockManagementState extends State<ControlStockManagement> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late DateTime iniDate, endDate;

  final controlService = ControlService();
  final productService = ProductService();
  final providerService = ProviderService();

  bool loading = false;
  ProviderData? _selectedProvider;

  List<StockData> stockList = [];
  Set<StockData> selectedStockListToShare = {};
  List<ProductData> productList = [];

  final stockDefaultController = TextEditingController();
  final stockDefaultNode = FocusNode();

  @override
  void initState() {
    super.initState();

    iniDate = StockModel.of(context).iniDateAll;
    endDate = StockModel.of(context).endDateAll;

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    stockList = StockModel.of(context).stockListAll;
    if (stockList.isNotEmpty) {
      _selectedProvider = stockList.first.product.provider;
    }
    stockDefaultController.text = '0';
    _updateProductList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool desktop = size.width > 600 ? true : false;

    void _updateProductAndStockItem(StockData stockItem) async {
      setState(() {
        loading = true;
      });

      final lastProvider = stockItem.product.provider;

      ProductData? recProd = await productService.createOrUpdate(
          product: stockItem.product,
          productList: [stockItem.product],
          context: context);

      if (recProd != null) {
        stockItem.product = recProd;

        await controlService.updateStockItem(context, stockItem);

        setState(() {
          _setProviderList(iniDate, endDate);
          _setStockListByProvider(iniDate, endDate, lastProvider);
          loading = false;
        });
      }
    }

    var dropDownProvidersItems = StockModel.of(context)
        .providerListAll
        .map(
          (e) => DropdownMenuItem(
            child: Text(e.name + ' - ' + e.location),
            value: e,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
        centerTitle: true,
        actions: [
          _selectedProvider != null ?
          IconButton(onPressed: (){
            _setStockListByProvider(iniDate, endDate, _selectedProvider!);
          }, icon: const Icon(Icons.refresh)) : Container(),
          IconButton(
              onPressed: () {
                if (_selectedProvider != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareStockItemsByProvider(
                              providerName: _selectedProvider!.name,
                              stockList: selectedStockListToShare.isEmpty
                                  ? stockList
                                  : selectedStockListToShare.toList())));
                }
              },
              icon: const Icon(Icons.share)),
          PopupMenuButton(
            color: CustomColors.backgroundTile,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: EnumControlHomePage.addProduct,
                child: Text(
                  'Adicionar Produto',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.loadDefaultStock,
                child: Text(
                  'Carregar Produtos Padrão',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.editDefaultStock,
                child: Text(
                  'Editar Produtos Padrão',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.duplicateStock,
                child: Text(
                  'Dividir Entre Fornecedores',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.changeStockData,
                child: Text(
                  'Alterar Data',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.showOrder,
                child: Text(
                  'Ver Pedidos',
                  style: TextStyle(color: CustomColors.textColorTile),
                ),
              ),
            ],
            onSelected: (value) async {
              ProductData? _selectedProduct;

              if (value == EnumControlHomePage.addProduct) {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return ShowProductListDialog(
                        productList: productList,
                        selectedProduct: (product) {
                          _selectedProduct = product;
                        },
                        longPressSelectedProduct: (product) {},
                      );
                    });

                if (_selectedProduct != null) {
                  loading = true;
                  setState(() {
                    _selectedProvider = _selectedProduct!.provider;
                  });

                  await controlService.addEmptyProductInStock(
                      _selectedProduct!, context, iniDate, endDate);
                  await _setProviderList(iniDate, endDate);
                  _setStockListByProvider(
                      iniDate, endDate, _selectedProduct!.provider);
                  loading = false;
                }
              } else if (value == EnumControlHomePage.loadDefaultStock) {
                setState(() {
                  loading = true;
                });
                await controlService.loadEmptyProductsListInStock(context);
                _setProviderList(iniDate, endDate);
                setState(() {
                  loading = false;
                });
              } else if (value == EnumControlHomePage.editDefaultStock) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StockDefaultList()));
              } else if (value == EnumControlHomePage.showOrder) {
                if (selectedStockListToShare.isEmpty) {
                  _showSnackBarError('Nenhum produto selecionado');
                } else if (selectedStockListToShare.length > 1) {
                  _showSnackBarError('Selecione apenas um produto');
                } else {
                  final product = selectedStockListToShare.first.product;

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return TransactionsDialog(
                            product: product,
                            iniDate: iniDate,
                            endDate: endDate);
                      });
                }
              } else if (value == EnumControlHomePage.duplicateStock) {
                if (selectedStockListToShare.isEmpty) {
                  _showSnackBarError('Nenhum produto selecionado');
                } else if (selectedStockListToShare.length > 1) {
                  _showSnackBarError('Selecione apenas um produto');
                } else {
                  var toDivideStock = selectedStockListToShare.first;

                  var providerAllList = await _getAllProviders();

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return ShowProviderListDialog(
                          selectedProvider: (provider) {
                            toDivideStock.product.provider = provider;
                          },
                          providerList: providerAllList);
                    },
                  );

                  await _setStockListByProvider(
                      iniDate, endDate, toDivideStock.product.provider);

                  controlService.addEmptyDuplicatedProductInStock(
                      toDivideStock.product,
                      StockModel.of(context).providerListAll,
                      stockList,
                      context);
                }
                await _setProviderList(iniDate, endDate);
              } else if (value == EnumControlHomePage.changeStockData) {
                if (selectedStockListToShare.isEmpty) {
                  _showSnackBarError('Nenhum produto selecionado');
                } else if (selectedStockListToShare.length > 1) {
                  _showSnackBarError('Selecione apenas um produto');
                } else {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050))
                      .then((value) {
                    if (value != null) {
                      final stock = selectedStockListToShare.first;
                      stock.creationDate = value;
                      controlService.updateStockItem(context, stock);
                      _setStockListByProvider(
                          iniDate, endDate, _selectedProvider!);
                    }
                  });
                }
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(4, desktop ? 10 : 4, 4, 4),
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: desktop ? 1080 : double.maxFinite),
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: iniDate,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            setState(() {
                              if (value != null) {
                                if (value != iniDate) {
                                  stockList.clear();
                                  _selectedProvider = null;
                                  iniDate = value;
                                }
                              }
                            });
                          });
                        },
                        child: Text(dateFormat.format(iniDate))),
                    SizedBox(
                      width: desktop ? 20 : 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            setState(() {
                              if (value != null) {
                                if (value != endDate) {
                                  stockList.clear();
                                  _selectedProvider = null;
                                  endDate = value;
                                }
                              }
                            });
                          });
                        },
                        child: Text(dateFormat.format(endDate))),
                    SizedBox(
                      width: desktop ? 20 : 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _setProviderList(iniDate, endDate);
                        },
                        child: const Text(
                          'Carregar Fornecedores',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: desktop ? 25 : 10,
                ),
                loading
                    ? const LinearProgressIndicator()
                    : StockModel.of(context).providerListAll.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Nenhum Fornecedor encontrado',
                                style: TextStyle(
                                    color: CustomColors.textColorTile),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: DropdownButtonFormField<ProviderData>(
                                  value: _selectedProvider,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: CustomColors.textColorTile),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: CustomColors.backgroundTile,
                                    label: const Text(
                                      'Fornecedor',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.textColorTile),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius:
                                            (BorderRadius.circular(16))),
                                  ),
                                  dropdownColor: CustomColors.backgroundTile,
                                  items: dropDownProvidersItems,
                                  onChanged: (e) {
                                    setState(() {
                                      if (e != null) {
                                        _selectedProvider = e;
                                        stockList.clear();
                                        _setStockListByProvider(iniDate,
                                            endDate, _selectedProvider!);
                                        //FocusScope.of(context).requestFocus(FocusNode());
                                        //stockDefaultNode.requestFocus();
                                        selectedStockListToShare.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Form(
                                        child: TextFormField(
                                          controller: stockDefaultController,
                                          focusNode: stockDefaultNode,
                                          enabled: iniDate == endDate,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color:
                                                  CustomColors.textColorTile),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor:
                                                CustomColors.backgroundTile,
                                            label: const Text(
                                              'Sobra Padrão',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: CustomColors
                                                      .textColorTile),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    (BorderRadius.circular(
                                                        16))),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          validator: (e) {
                                            var regExp = RegExp(
                                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                                .hasMatch(e!);
                                            if (stockDefaultController
                                                    .text.isEmpty ||
                                                !regExp) {
                                              return '';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (e) async {
                                            setState(() {
                                              loading = true;
                                            });
                                            int left = int.parse(
                                                stockDefaultController.text);

                                            controlService
                                                .updateTotalOrderedInAllStockByProvider(
                                                    context, stockList, left);

                                            if (_selectedProvider != null) {
                                              await _setStockListByProvider(
                                                  iniDate,
                                                  endDate,
                                                  _selectedProvider!);
                                            }

                                            setState(() {
                                              loading = false;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                stockList.isEmpty
                    ? Container()
                    : SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Produto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Pedido',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Sobra',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                loading
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: stockList.length,
                          itemBuilder: (context, index) {
                            var stockIndex = stockList[index];
                            return InkWell(
                              onLongPress: () {
                                setState(() {
                                  if (selectedStockListToShare
                                      .contains(stockIndex)) {
                                    selectedStockListToShare.remove(stockIndex);
                                  } else {
                                    selectedStockListToShare.add(stockIndex);
                                  }
                                });
                              },
                              child: ListTile(
                                title: StockListTile(
                                  stock: stockIndex,
                                  editable: iniDate == endDate,
                                  selected: selectedStockListToShare
                                      .contains(stockIndex),
                                  onDelete: () async {
                                    StockModel.of(context)
                                        .deleteStock(stockIndex);
                                    setState(() {
                                      loading = true;
                                    });
                                    stockList.remove(stockIndex);
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                  onEdit: () async {
                                    setState(() {
                                      _updateProductAndStockItem(stockIndex);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setStockListByProvider(
      DateTime iniDate, DateTime endDate, ProviderData provider) async {
    if (mounted) {
      setState(() {
        loading = true;
      });

      final list = await StockModel.of(context)
          .getAllStocksByDateAndProvider(iniDate, endDate, provider);

      setState(() {
        stockList = list;
        loading = false;
      });
    }
  }

  Future<void> _setProviderList(DateTime iniDate, DateTime endDate) async {
    if (mounted) {
      setState(() {
        stockList.clear();
        loading = true;
        _selectedProvider = null;
      });

      final list = await StockModel.of(context)
          .getAllStockProvidersByDate(iniDate, endDate);

      setState(() {
        StockModel.of(context).providerListAll = list.toList();
        providerService.sortProviderListByEstablishmentAndRegistration(
            StockModel.of(context).providerListAll);
        loading = false;
      });
    }
  }

  Future<List<ProviderData>> _getAllProviders() async {
    List<ProviderData> providerList = [];
    if (mounted) {
      final list = await ProviderModel.of(context).getEnabledProviders();

      setState(() {
        providerList = list;
      });
    }

    return providerList;
  }

  Future<void> _updateProductList() async {
    if (mounted) {
      final list = await ProductModel.of(context).getFilteredEnabledProducts();

      setState(() {
        productList = list;
      });
    }
  }

  _showSnackBarError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: CustomColors.backgroundTile,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }
}
