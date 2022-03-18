import 'package:controle_pedidos/data/establishment_data.dart';
import 'package:controle_pedidos/model/establishment_model.dart';
import 'package:controle_pedidos/services/establishment_service.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:controle_pedidos/widgets/tiles/establishment_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'establishment_registration_page.dart';

class EstablishmentListPage extends StatefulWidget {
  const EstablishmentListPage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _EstablishmentListPageState createState() => _EstablishmentListPageState();
}

class _EstablishmentListPageState extends State<EstablishmentListPage> {
  final service = EstablishmentService();
  List<EstablishmentData> estabList = [];

  @override
  void initState() {
    super.initState();

    _getEstabList();
  }

  void _showClientRegistrationPage({EstablishmentData? estab}) async {
    final recEstab = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EstablishmentRegistrationPage(
                  establishment: estab,
                )));

    if (recEstab != null) {
      if (estab != null) {
        setState(() {
          EstablishmentModel.of(context).updateEstablishment(recEstab);
          estabList.remove(estab);
        });
      } else {
        EstablishmentModel.of(context).createEstablishment(recEstab);
      }
    }
    setState(() {
      estabList.add(recEstab);
      service.sortEstablishmentsByName(estabList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Estabelecimentos'),
          centerTitle: true,
        ),
        drawer: CustomDrawer(
          pageController: widget.pageController,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showClientRegistrationPage();
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: CustomColors.backgroundColor,
        body: ListView.builder(
          itemCount: estabList.length,
          itemBuilder: (context, index) {
            var item = estabList[index];
            return Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: null,
                children: [
                  SlidableAction(
                    onPressed: (e) {
                      setState(() {
                        EstablishmentModel.of(context)
                            .disableEstablishment(item);
                        estabList.remove(item);
                      });
                    },
                    icon: Icons.delete_forever,
                    label: 'Apagar',
                    backgroundColor: Colors.red,
                  ),
                  SlidableAction(
                    onPressed: (e) {
                      setState(() {
                        _showClientRegistrationPage(estab: item);
                      });
                    },
                    icon: Icons.edit,
                    label: 'Editar',
                    backgroundColor: Colors.deepPurple,
                  )
                ],
              ),
              child: EstablishmentListTile(establishment: item),
            );
          },
        ));
  }

  void _getEstabList() async {
    if (mounted) {
      final list =
          await EstablishmentModel.of(context).getEnabledEstablishments();

      setState(() {
        estabList = list;
      });
    }
  }
}
