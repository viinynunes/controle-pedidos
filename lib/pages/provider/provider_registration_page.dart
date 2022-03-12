import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/data/provider_data.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/model/provider_model.dart';
import 'package:controle_pedidos/pages/establishment/establishment_registration_page.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProviderRegistrationPage extends StatefulWidget {
  const ProviderRegistrationPage({Key? key, this.provider}) : super(key: key);

  final ProviderData? provider;

  @override
  _ProviderRegistrationPageState createState() =>
      _ProviderRegistrationPageState();
}

class _ProviderRegistrationPageState extends State<ProviderRegistrationPage> {
  late ProviderData newProvider;

  bool loading = false;

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  EstablishmentData? _selectedEstablishment;
  late List<EstablishmentData> _establishmentList = [];

  @override
  void initState() {
    super.initState();

    if (widget.provider == null) {
      newProvider = ProviderData();
      _getEstabList();
    } else {
      newProvider = ProviderData.fromMap(widget.provider!.toMap());
      _nameController.text = newProvider.name;
      _locationController.text = newProvider.location;
      _getEstabList(provider: newProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dropDownItems = _establishmentList
        .map((e) => DropdownMenuItem(
              child: Text(
                e.enabled == true
                    ? e.name
                    : e.name + ' - ESTABELECIMENTO APAGADO',
                style: (TextStyle(
                  color: e.enabled == false ? Colors.red : CustomColors.textColorTile,
                )),
              ),
              value: e,
            ))
        .toList();

    return ScopedModelDescendant<ProviderModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(_nameController.text.isEmpty
              ? 'Novo Fornecedor'
              : _nameController.text),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _getFields();
              Navigator.pop(context, newProvider);
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
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: _getStyle(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Localização',
                      labelStyle: _getStyle(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    style: _getStyle(),
                    validator: (e) {
                      if (_locationController.text.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  loading
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<EstablishmentData>(
                          items: dropDownItems,
                          elevation: 10,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          isExpanded: true,
                          decoration: InputDecoration(
                            label: const Text(
                              'Estabelecimento',
                              style: TextStyle(fontSize: 20, color: CustomColors.textColorTile),
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
                              _selectedEstablishment = e;
                            });
                          },
                          value: _selectedEstablishment,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EstablishmentRegistrationPage()));
                          _getEstabList();
                        },
                        child: const Text(
                          'Criar novo Estabelecimento',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.textColorTile),
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

  void _getEstabList({ProviderData? provider}) async {
    setState(() {
      loading = true;
    });
    if (provider == null) {
      _establishmentList =
          await EstablishmentModel.of(context).getEnabledEstablishments();
      _selectedEstablishment = _establishmentList.first;
    } else {
      _establishmentList =
          await EstablishmentModel.of(context).getAllEstablishments();
      _selectedEstablishment = _establishmentList
          .firstWhere((element) => element.id == provider.establishment.id);
    }

    if (provider == null) {
    } else {}
    setState(() {
      loading = false;
    });
  }

  void _getFields() {
    newProvider.name = _nameController.text;
    newProvider.location = _locationController.text;
    newProvider.establishment = _selectedEstablishment!;
    newProvider.enabled = true;
    newProvider.registrationDate = widget.provider == null ? DateTime.now() : widget.provider!.registrationDate;
  }

  TextStyle _getStyle() {
    return const TextStyle(color: CustomColors.textColorTile);
  }
}
