import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/data/stock_data.dart';
import 'package:controle_pedidos/model/stock_model.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/stock_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  bool loading = false;
  List<ProviderData> providersList = [];
  ProviderData? _selectedProvider;

  List<StockData> stockList = [];

  @override
  void initState() {
    super.initState();

    iniDate = DateTime.now();
    endDate = DateTime.now();

    iniDate = DateTime(iniDate.year, iniDate.month, iniDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
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
                                  style: TextStyle(fontSize: 16, color: Colors.black),
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
                        ],
                      ),
            loading
                ? const LinearProgressIndicator()
                : SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        children: const [
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Text('Produto', textAlign: TextAlign.center,),
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
}
