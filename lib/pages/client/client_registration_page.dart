import 'package:controle_pedidos/data/client_data.dart';
import 'package:flutter/material.dart';

class ClientRegistrationPage extends StatefulWidget {
  const ClientRegistrationPage({Key? key, this.client}) : super(key: key);

  final ClientData? client;

  @override
  _ClientRegistrationPageState createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late ClientData newClientData;

  @override
  void initState() {
    super.initState();

    if (widget.client == null) {
      newClientData = ClientData.empty();
    } else {
      newClientData = ClientData.fromMap(widget.client!.toMap());
      _nameController.text = newClientData.name;
      _emailController.text = newClientData.email ?? '';
      _phoneController.text = newClientData.phone ?? '';
      _addressController.text = newClientData.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_nameController.text.isEmpty
            ? 'Novo Cliente'
            : _nameController.text),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _getFields();
            Navigator.pop(context, newClientData);
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
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  validator: (text) {
                    bool regValida = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text!);
                    if (text.isNotEmpty && !regValida) {
                      return 'Email Inválido';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getFields() {
    newClientData.name = _nameController.text;
    newClientData.email = _emailController.text;
    newClientData.phone = _phoneController.text;
    newClientData.address = _addressController.text;
    newClientData.enabled = true;
  }
}
