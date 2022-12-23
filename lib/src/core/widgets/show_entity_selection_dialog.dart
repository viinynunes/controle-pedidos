import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'custom_text_form_field.dart';
import 'stores/show_entity_selection_dialog_controller.dart';

class ShowEntitySelectionDialog extends StatefulWidget {
  const ShowEntitySelectionDialog(
      {Key? key,
      required this.entityList,
      this.fromKeyboardSelection,
      this.fromTileSelection})
      : super(key: key);

  final List entityList;
  final Function(Object? entity)? fromKeyboardSelection;
  final Function(Object? entity)? fromTileSelection;

  @override
  State<ShowEntitySelectionDialog> createState() =>
      _ShowEntitySelectionDialogState();
}

class _ShowEntitySelectionDialogState extends State<ShowEntitySelectionDialog> {
  final controller = GetIt.I.get<ShowEntitySelectionDialogController>();

  @override
  void initState() {
    super.initState();

    controller.initState(widget.entityList);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          CustomTextFormField(
            controller: controller.searchController,
            focus: controller.searchFocus,
            label: 'Pesquisar',
            onChanged: (text) {
              controller.searchText = text;
              controller.filterEntityList();
            },
            onSubmitted: (e) {
              Navigator.of(context).pop(controller.filteredObjectList.first);
              if (widget.fromKeyboardSelection != null) {
                widget.fromKeyboardSelection!(
                    controller.filteredObjectList.first);
              }
            },
            textInputType: TextInputType.url,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () => controller.callEntityRegistrationPage(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Novo',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Icon(Icons.add),
              ],
            ),
          )
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.maxFinite,
        child: Observer(
          builder: (_) {
            var entityList = controller.filteredObjectList;

            return ListView.builder(
              itemCount: entityList.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final entity = entityList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(entity);

                    if (widget.fromTileSelection != null) {
                      widget.fromTileSelection!(entity);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            entity.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
