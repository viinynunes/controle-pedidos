import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/widgets/tiles/establishment_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'establishment_registration_page.dart';

class EstablishmentListPage extends StatefulWidget {
  const EstablishmentListPage({Key? key}) : super(key: key);

  @override
  _EstablishmentListPageState createState() => _EstablishmentListPageState();
}

class _EstablishmentListPageState extends State<EstablishmentListPage> {
  void _showClientRegistrationPage(EstablishmentData? estab) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EstablishmentRegistrationPage(
                  establishment: estab,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<EstablishmentModel>(
        builder: (context, child, model) {
      if (model.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return FutureBuilder<List<EstablishmentData>>(
          future: model.getEnabledEstablishments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: null,
                    children: [
                      SlidableAction(
                        onPressed: (e) {
                          setState(() {
                            model.disableEstablishment(snapshot.data![index]);
                          });
                        },
                        icon: Icons.delete_forever,
                        label: 'Apagar',
                        backgroundColor: Colors.red,
                      ),
                      SlidableAction(
                        onPressed: (e) {
                          setState(() {
                            _showClientRegistrationPage(snapshot.data![index]);
                          });
                        },
                        icon: Icons.edit,
                        label: 'Editar',
                        backgroundColor: Colors.deepPurple,
                      )
                    ],
                  ),
                  child: EstablishmentListTile(
                      establishment: snapshot.data![index]),
                ),
              );
            }
          });
    });
  }
}
