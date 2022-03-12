import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:controle_pedidos/pages/control/share_stock_Items_by_provider.dart';
import 'package:controle_pedidos/pages/product/showProductListDialog.dart';
import 'package:controle_pedidos/services/control_service.dart';
import 'package:controle_pedidos/services/provider_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/utils/enum_control_home_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/stock_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/product_data.dart';
import '../stockDefault/stock_default_list.dart';

class ControlHomePage extends StatefulWidget {
  const ControlHomePage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ControlHomePageState createState() => _ControlHomePageState();
}

class _ControlHomePageState extends State<ControlHomePage> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late DateTime iniDate, endDate;

  ControlService controlService = ControlService();

  bool loading = false;
  List<ProviderData> providersList = [];
  ProviderData? _selectedProvider;

  List<StockData> stockList = [];
  Set<StockData> selectedStockListToShare = {};
  List<ProductData> productList = [];

  final stockDefaultController = TextEditingController();
  final stockDefaultNode = FocusNode();

  @override
  void initState() {
    super.initState();

    iniDate = DateTime.now();
    endDate = DateTime.now();

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    stockDefaultController.text = '0';
    stockDefaultController.selection = TextSelection(
        baseOffset: 0, extentOffset: stockDefaultController.value.text.length);
    _updateProductList();
  }

  @override
  Widget build(BuildContext context) {
    var dropDownProvidersItems = providersList
        .map(
          (e) => DropdownMenuItem(
            child: Text(e.name),
            value: e,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
        centerTitle: true,
        actions: [
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
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: EnumControlHomePage.addProduct,
                child: Text('Adicionar Produto'),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.loadDefaultStock,
                child: Text('Carregar Produtos Padrão'),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.editDefaultStock,
                child: Text('Editar Produtos Padrão'),
              ),
            ],
            onSelected: (value) async {
              if (value == EnumControlHomePage.addProduct) {
                ProductData? _selectedProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowProductListDialog(productList: productList)));

                if (_selectedProduct != null) {
                  loading = true;
                  setState(() {
                    _selectedProvider = _selectedProduct.provider;
                  });

                  await controlService.addEmptyProductInStock(
                      _selectedProduct, context, iniDate, endDate);
                  await _setProviderList(iniDate, endDate);
                  _setStockListByProvider(
                      iniDate, endDate, _selectedProduct.provider);
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
        padding: const EdgeInsets.all(4),
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
                const SizedBox(
                  width: 10,
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
                const SizedBox(
                  width: 10,
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
            const SizedBox(
              height: 10,
            ),
            loading
                ? const LinearProgressIndicator()
                : providersList.isEmpty
                    ? const Center(
                        child: Text('Busque por fornecedores', style: TextStyle(color: CustomColors.textColorTile),),
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
                                  fontSize: 16, color: CustomColors.textColorTile),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: CustomColors.backgroundTile,
                                label: const Text(
                                  'Fornecedor',
                                  style: TextStyle(
                                      fontSize: 16, color: CustomColors.textColorTile),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.deepPurple),
                                    borderRadius: (BorderRadius.circular(16))),
                              ),
                              dropdownColor: CustomColors.backgroundTile,
                              items: dropDownProvidersItems,
                              onChanged: (e) {
                                setState(() {
                                  if (e != null) {
                                    _selectedProvider = e;
                                    stockList.clear();
                                    _setStockListByProvider(
                                        iniDate, endDate, _selectedProvider!);
                                    stockDefaultNode.requestFocus();
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
                                      style: const TextStyle(fontSize: 20, color: CustomColors.textColorTile),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: CustomColors.backgroundTile,
                                        label: const Text(
                                          'Sobra Padrão',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: CustomColors.textColorTile),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                            borderRadius:
                                                (BorderRadius.circular(16))),
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

                                        await controlService
                                            .updateTotalOrderedInAllStockByProvider(
                                                context, stockList, left);

                                        if (_selectedProvider != null) {
                                          await _setStockListByProvider(iniDate,
                                              endDate, _selectedProvider!);
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
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text(
                              'Produto',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text('Pedido', textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                          ),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text('Total', textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text('Sobra', textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
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
                              selected: selectedStockListToShare.contains(stockIndex),
                              onDelete: () async {
                                await StockModel.of(context)
                                    .deleteStock(stockIndex);
                                setState(() {
                                  loading = true;
                                });
                                if (_selectedProvider != null) {
                                  _setStockListByProvider(
                                      iniDate, endDate, _selectedProvider!);
                                }
                                setState(() {
                                  loading = false;
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
    );
  }

  Future<void> _setStockListByProvider(
      DateTime iniDate, DateTime endDate, ProviderData provider) async {
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

  Future<void> _setProviderList(DateTime iniDate, DateTime endDate) async {
    setState(() {
      stockList.clear();
      loading = true;
      _selectedProvider = null;
    });

    final list = await StockModel.of(context)
        .getAllStockProvidersByDate(iniDate, endDate);

    final service = ProviderService();

    service.sortProviderListByEstablishmentAndRegistration(list.toList());

    setState(() {
      providersList = list.toList();
      loading = false;
    });
  }

  void _updateProductList() async {
    setState(() {
      loading = true;
    });
    final list = await ProductModel.of(context).getFilteredEnabledProducts();

    setState(() {
      productList = list;
      loading = false;
    });
  }
}
