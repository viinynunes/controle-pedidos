import 'package:controle_pedidos/src/modules/establishment/presenter/stores/establishment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/ui/states/base_state.dart';
import '../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import 'android_establishment_registration_page.dart';
import 'tiles/android_establishment_list_tile.dart';

class AndroidEstablishmentListPage extends StatefulWidget {
  const AndroidEstablishmentListPage({Key? key}) : super(key: key);

  @override
  State<AndroidEstablishmentListPage> createState() =>
      _AndroidEstablishmentListPageState();
}

class _AndroidEstablishmentListPageState
    extends BaseState<AndroidEstablishmentListPage, EstablishmentController> {
  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => controller.searching
              ? TextField(
                  focusNode: controller.searchFocus,
                  decoration: const InputDecoration(hintText: 'Pesquisar'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (text) {
                    controller.searchText = text;
                    controller.filterEstablishmentListByText();
                  },
                )
              : const Text('Estabelecimentos'),
        ),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.searching
                ? IconButton(
                    onPressed: () {
                      controller.searching = false;
                      controller.searchText = '';
                      controller.getEstablishmentList();
                    },
                    icon: const Icon(Icons.clear))
                : IconButton(
                    onPressed: () {
                      controller.searching = true;
                      controller.searchFocus.requestFocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.callEstablishmentRegistrationPage(
            context: context,
            registrationPage: const AndroidEstablishmentRegistrationPage()),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Observer(
              builder: (_) {
                var estabList = [];

                if (controller.loading) {
                  return ShimmerListBuilder(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.maxFinite,
                      itemCount: 10);
                }

                if (controller.searching && controller.searchText.isNotEmpty) {
                  estabList = controller.filteredEstabList;
                } else {
                  estabList = controller.estabList;
                }

                return estabList.isNotEmpty
                    ? ListView.builder(
                        itemCount: estabList.length,
                        itemBuilder: (_, index) {
                          final establishment = estabList[index];

                          return AndroidEstablishmentListTile(
                            establishment: establishment,
                            onTap: () {
                              controller.callEstablishmentRegistrationPage(
                                  context: context,
                                  registrationPage:
                                      AndroidEstablishmentRegistrationPage(
                                    establishment: establishment,
                                  ));
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text('Nenhum estabelecimento encontrado'),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
