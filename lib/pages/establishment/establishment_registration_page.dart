import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EstablishmentRegistrationPage extends StatefulWidget {
  const EstablishmentRegistrationPage({Key? key, this.establishment}) : super(key: key);

  final EstablishmentData? establishment;

  @override
  _EstablishmentRegistrationPageState createState() => _EstablishmentRegistrationPageState();
}

class _EstablishmentRegistrationPageState extends State<EstablishmentRegistrationPage> {

  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late EstablishmentData newEstablishment;

  @override
  void initState() {
   super.initState();

   if (widget.establishment == null){
     newEstablishment = EstablishmentData();
   } else {
     newEstablishment = EstablishmentData.fromMap(widget.establishment!.toMap());
     _nameController.text = newEstablishment.name;
   }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<EstablishmentModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(_nameController.text.isEmpty ? 'Novo Estabelecimento' : _nameController.text),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              _getFields();
              if (widget.establishment == null){
                model.createEstablishment(newEstablishment);
              } else {
                model.updateEstablishment(newEstablishment);
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
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  )
                ),
                validator: (text){
                  if(_nameController.text.isEmpty){
                    return 'Campo Obrigatório';
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getFields(){
    newEstablishment.name = _nameController.text;
    newEstablishment.enabled = true;
  }
}
