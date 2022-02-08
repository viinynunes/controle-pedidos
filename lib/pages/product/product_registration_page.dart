import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/pages/provider/provider_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductRegistrationPage extends StatefulWidget {
  const ProductRegistrationPage({Key? key, this.product}) : super(key: key);

  final ProductData? product;

  @override
  _ProductRegistrationPageState createState() =>
      _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late ProductData newProduct;
  List<ProviderData> _providerList = [];
  ProviderData? _selectedProvider;

  @override
  void initState() {
    super.initState();

    if (widget.product == null) {
      newProduct = ProductData();
      _getProvidersList();
    } else {
      newProduct = ProductData.fromMap(widget.product!.toMap());
      _nameController.text = newProduct.name;
      _categoryController.text = newProduct.category;
      _getProvidersList(product: newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dropDownItems = _providerList
        .map(
          (e) => DropdownMenuItem(
            child: Text(e.name),
            value: e,
          ),
        )
        .toList();

    return ScopedModelDescendant<ProductModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(_nameController.text.isEmpty
              ? 'Novo Produto'
              : _nameController.text),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _getFields();
              if (widget.product == null) {
                model.createProduct(newProduct);
              } else {
                model.updateProduct(newProduct);
              }
              Navigator.pop(context);
            }
          },
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    validator: (e) {
                      if (_nameController.text.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _categoryController,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    validator: (e) {
                      if (_categoryController.text.isEmpty) {
                        return 'Campo Obrigatório';
                      } else if (_categoryController.text.length > 3) {
                        return 'Maxímo 3 caracteres';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField<ProviderData>(
                    items: dropDownItems,
                    elevation: 10,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    isExpanded: true,
                    decoration: InputDecoration(
                      label: const Text(
                        'Fornecedor',
                        style: TextStyle(fontSize: 20),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: (BorderRadius.circular(16))),
                    ),
                    onChanged: (e) {
                      setState(() {
                        _selectedProvider = e;
                      });
                    },
                    value: _selectedProvider,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProviderRegistrationPage()));
                            _getProvidersList();
                        },
                        child: const Text('Criar novo fornecedor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getProvidersList({ProductData? product}) async {
    _providerList = await ProviderModel.of(context).getEnabledProviders();
    if (product == null) {
      _selectedProvider = _providerList.first;
    } else {
      _selectedProvider = _providerList
          .firstWhere((element) => element.id == product.provider.id);
    }
    setState(() {});
  }

  void _getFields() {
    newProduct.name = _nameController.text;
    newProduct.category = _categoryController.text;
    newProduct.provider = _selectedProvider!;
    newProduct.enabled = true;
  }
}
