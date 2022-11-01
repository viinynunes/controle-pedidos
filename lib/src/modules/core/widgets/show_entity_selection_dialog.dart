import 'package:controle_pedidos/src/modules/core/widgets/custom_text_form_field.dart';
import 'package:controle_pedidos/src/modules/core/widgets/stores/show_entity_selection_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ShowEntitySelectionDialog extends StatefulWidget {
  const ShowEntitySelectionDialog({Key? key, required this.entityList})
      : super(key: key);

  final List entityList;

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
            },
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
        height: MediaQuery.of(context).size.height * 0.25,
        child: Observer(
          builder: (_) {
            var entityList = controller.filteredObjectList;

            return ListView.builder(
              itemCount: entityList.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final entity = entityList[index];

                return GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
