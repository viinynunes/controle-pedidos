import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:controle_pedidos/pages/control/share_stock_Items_by_provider.dart';
import 'package:controle_pedidos/pages/product/showProductListDialog.dart';
import 'package:controle_pedidos/services/control_service.dart';
import 'package:controle_pedidos/utils/enum_control_home_page.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/stock_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/product_data.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                if (_selectedProvider != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareStockItemsByProvider(
                              providerName: _selectedProvider!.name,
                              stockList: stockList)));
                }
              },
              icon: const Icon(Icons.share)),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: EnumControlHomePage.item1,
                child: Text('Carregar Produtos Padrão'),
              ),
              const PopupMenuItem(
                value: EnumControlHomePage.item2,
                child: Text('Adicionar Produto'),
              ),
            ],
            onSelected: (value) async {
              if (value == EnumControlHomePage.item1) {
                print('Carregar produtos padrão');
              } else if (value == EnumControlHomePage.item2) {
                ProductData? _selectedProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowProductListDialog(productList: productList)));

                if (_selectedProduct != null){
                  loading = true;
                  await controlService.addEmptyProductInStock(_selectedProduct, context, iniDate, endDate);
                  _selectedProvider = _selectedProduct.provider;
                  _setStockListByProvider(iniDate, endDate, _selectedProvider!);
                  loading = false;
                }
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      backgroundColor: Colors.grey[250],
      body: Padding(
        padding: const EdgeInsets.all(5),
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
                        child: Text('Nenhum fornecedor encontrado'),
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
                                  fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                label: const Text(
                                  'Fornecedor',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: (BorderRadius.circular(16))),
                              ),
                              items: dropDownProvidersItems,
                              onChanged: (e) {
                                setState(() {
                                  if (e != null) {
                                    _selectedProvider = e;
                                    stockList.clear();
                                    _setStockListByProvider(
                                        iniDate, endDate, _selectedProvider!);
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
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        label: const Text(
                                          'Sobra Padrão',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(),
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
                        children: const [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text(
                              'Produto',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text('Pedido', textAlign: TextAlign.center),
                          ),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text('Total', textAlign: TextAlign.center),
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text('Sobra', textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: stockList.length,
                itemBuilder: (context, index) {
                  var stockIndex = stockList[index];
                  return ListTile(
                    title: StockListTile(
                      stock: stockIndex,
                      editable: iniDate == endDate,
                      onDelete: () async {
                        loading = true;
                        await StockModel.of(context).deleteStock(stockIndex);
                        if (_selectedProvider != null){
                          _setStockListByProvider(iniDate, endDate, _selectedProvider!);
                        }

                        loading = false;
                      },
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
