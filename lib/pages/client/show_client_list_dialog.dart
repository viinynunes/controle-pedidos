import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ShowClientListDialog extends StatefulWidget {
  const ShowClientListDialog(
      {Key? key, required this.clientList, required this.selectedClient})
      : super(key: key);

  final Function(ClientData) selectedClient;
  final List<ClientData> clientList;

  @override
  _ShowProductListDialogState createState() => _ShowProductListDialogState();
}

class _ShowProductListDialogState extends State<ShowClientListDialog> {
  ClientData? client;
  List<ClientData> clientList = [];
  List<ClientData> secondaryClientList = [];

  final _searchController = TextEditingController();
  final _searchNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.clientList.isNotEmpty) {
      clientList = widget.clientList;
      secondaryClientList.addAll(clientList);
    }

    _searchNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 50,
      backgroundColor: CustomColors.backgroundColor,
      title: Column(
        children: [
          const Text(
            'Selecione um cliente',
            textAlign: TextAlign.center,
            style: TextStyle(color: CustomColors.textColorTile),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _searchController,
            focusNode: _searchNode,
            decoration: InputDecoration(
              labelText: 'Procurar Cliente',
              labelStyle: const TextStyle(color: CustomColors.textColorTile),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
            ),
            style: const TextStyle(color: CustomColors.textColorTile),
            onChanged: (e) {
              _filterProductList(e);
            },
            onSubmitted: (e) {
              _selectClient(secondaryClientList.first);
            },
          ),
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: secondaryClientList.length,
          itemBuilder: (context, index) {
            var item = secondaryClientList[index];
            return ListTile(
              textColor: CustomColors.textColorTile,
              title: Text(item.toString()),
              onTap: () {
                _selectClient(item);
              },
            );
          },
        ),
      ),
    );
  }

  void _filterProductList(String search) {
    List<ClientData> filteredList = [];
    filteredList.addAll(clientList);
    if (search.isNotEmpty) {
      List<ClientData> xList = [];
      for (var element in filteredList) {
        if (element.name.toLowerCase().contains(search.toLowerCase())) {
          xList.add(element);
        }
      }

      setState(() {
        secondaryClientList.clear();
        secondaryClientList.addAll(xList);
      });
      return;
    } else {
      setState(() {
        secondaryClientList.clear();
        secondaryClientList.addAll(clientList);
      });
    }
  }

  void _selectClient(ClientData item) {
    setState(() {
      widget.selectedClient(item);
      Navigator.pop(context);
    });
  }
}
