import 'package:controle_pedidos/data/product_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/product_model.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/services/provider_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
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

  final providerService = ProviderService();

  final _nameFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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

    _nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    var dropDownItems = _providerList
        .map(
          (e) => DropdownMenuItem(
            child: Text(
              e.enabled == true ? e.name : e.name + ' - FORNECEDOR APAGADO',
              style: (TextStyle(
                color: e.enabled == false
                    ? Colors.red
                    : CustomColors.textColorTile,
              )),
            ),
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
              Navigator.pop(context, newProduct);
            }
          },
          child: const Icon(Icons.save),
        ),
        backgroundColor: CustomColors.backgroundColor,
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
                    focusNode: _nameFocus,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Nome',
                      labelStyle: _getStyle(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    style: _getStyle(),
                    validator: (e) {
                      if (_nameController.text.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _categoryController,
                    maxLength: 3,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      labelStyle: _getStyle(),
                      counterStyle:
                          const TextStyle(color: CustomColors.textColorTile),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    style: _getStyle(),
                    validator: (e) {
                      if (_categoryController.text.isEmpty) {
                        return 'Campo Obrigatório';
                      } else if (_categoryController.text.length > 3) {
                        return 'Máxímo 3 caracteres';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  loading
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<ProviderData>(
                          value: _selectedProvider,
                          items: dropDownItems,
                          elevation: 10,
                          style: const TextStyle(fontSize: 20),
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
                                borderSide: const BorderSide(),
                                borderRadius: (BorderRadius.circular(16))),
                          ),
                          dropdownColor: CustomColors.backgroundTile,
                          validator: (e) {
                            if (e == null) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                          onChanged: (e) {
                            setState(() {
                              _selectedProvider = e;
                            });
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          await providerService.createOrUpdate(providerList: _providerList, context: context);
                          _getProvidersList();
                        },
                        child: const Text(
                          'Criar novo fornecedor',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textColorTile),
                        ),
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
    setState(() {
      loading = true;
    });
    if (product == null) {
      _providerList = await ProviderModel.of(context).getEnabledProviders();
      providerService.sortProviderListByEstablishmentAndRegistration(_providerList);
      _selectedProvider = _providerList.first;
    } else {
      _providerList = await ProviderModel.of(context).getAllProviders();
      providerService.sortProviderListByEstablishmentAndRegistration(_providerList);
      _selectedProvider = _providerList
          .firstWhere((element) => element.id == product.provider.id);
    }



    setState(() {
      loading = false;
    });
  }

  void _getFields() {
    newProduct.name = _nameController.text;
    newProduct.category = _categoryController.text;
    newProduct.provider = _selectedProvider!;
    newProduct.enabled = true;
    newProduct.stockDefault =
        widget.product != null ? widget.product!.stockDefault : false;
  }

  TextStyle _getStyle() {
    return const TextStyle(color: CustomColors.textColorTile);
  }
}
