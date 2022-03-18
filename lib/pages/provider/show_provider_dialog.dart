import 'package:flutter/material.dart';

import '../../data/provider_data.dart';
import '../../utils/custom_colors.dart';

class ShowProviderListDialog extends StatefulWidget {
  const ShowProviderListDialog(
      {Key? key, required this.selectedProvider, required this.providerList})
      : super(key: key);

  final Function(ProviderData) selectedProvider;
  final List<ProviderData> providerList;

  @override
  State<ShowProviderListDialog> createState() => _ShowProviderListDialogState();
}

class _ShowProviderListDialogState extends State<ShowProviderListDialog> {
  List<ProviderData> filteredProviderList = [];

  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    filteredProviderList.addAll(widget.providerList);
    _searchFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        backgroundColor: CustomColors.backgroundTile,
        title: TextField(
          focusNode: _searchFocus,
          decoration: InputDecoration(
            labelText: 'Pesquisar fornecedor',
            labelStyle: const TextStyle(color: CustomColors.textColorTile),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          style: const TextStyle(color: CustomColors.textColorTile),
          onChanged: (text) {
            _filterProviderList(text);
          },
          onSubmitted: (e) {
            _selectProvider(filteredProviderList.first);
          },
        ),
        content: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredProviderList.length,
            itemBuilder: (context, index) {
              var provider = filteredProviderList[index];
              return ListTile(
                title: Text(
                  provider.enabled == true
                      ? provider.name + ' - ' + provider.location
                      : provider.name +
                          ' - ' +
                          provider.location +
                          ' - FORNECEDOR APAGADO',
                  style: (TextStyle(
                    color: provider.enabled == false
                        ? Colors.red
                        : CustomColors.textColorTile,
                  )),
                ),
                onTap: () {
                  _selectProvider(provider);
                },
              );
            },
          ),
        ));
  }

  void _filterProviderList(String search) {
    List<ProviderData> _auxList = [];
    _auxList.addAll(widget.providerList);
    if (search.isNotEmpty) {
      List<ProviderData> _filteredList = [];
      for (var prov in _auxList) {
        if (prov.name.toLowerCase().contains(search.toLowerCase()) ||
            prov.location.toLowerCase().contains(search.toLowerCase())) {
          _filteredList.add(prov);
        }
      }

      setState(() {
        filteredProviderList.clear();
        filteredProviderList.addAll(_filteredList);
      });
      return;
    } else {
      setState(() {
        filteredProviderList.clear();
        filteredProviderList.addAll(widget.providerList);
      });
    }
  }

  void _selectProvider(ProviderData provider) {
    setState(() {
      widget.selectedProvider(provider);
      Navigator.pop(context);
    });
  }
}
