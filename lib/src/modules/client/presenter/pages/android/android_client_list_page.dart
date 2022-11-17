import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/widgets/custom_material_banner_error.dart';
import '../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../stores/client_controller.dart';
import 'android_client_registration_page.dart';
import 'tiles/android_client_list_tile.dart';

class AndroidClientListPage extends StatefulWidget {
  const AndroidClientListPage({Key? key}) : super(key: key);

  @override
  State<AndroidClientListPage> createState() => _AndroidClientListPageState();
}

class _AndroidClientListPageState extends State<AndroidClientListPage> {
  final controller = GetIt.I.get<ClientController>();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error
          .map((error) => CustomMaterialBannerError.showMaterialBannerError(
              context: context,
              message: 'Fornecedor Erro - ${error.message}',
              onClose: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                controller.getClientList();
              }));
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
                    decoration:
                        const InputDecoration(hintText: 'Pesquisar Cliente'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (text) {
                      controller.searchText = text;
                      controller.filterClientByText();
                    },
                  )
                : const Text('Clientes')),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.searching
                ? IconButton(
                    onPressed: () {
                      controller.searching = false;
                      controller.searchText = '';
                      controller.getClientList();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : IconButton(
                    onPressed: () {
                      controller.searching = true;
                      controller.searchFocus.requestFocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
          ),
          IconButton(
              onPressed: controller.getClientList,
              icon: const Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clientRegistrationPage(
              context: context,
              registrationPage: const AndroidClientRegistrationPage());
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Observer(
              builder: (_) {
                var clientList = [];

                if (controller.loading) {
                  return ShimmerListBuilder(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.maxFinite,
                      itemCount: 10);
                }

                if (controller.searching && controller.searchText.isNotEmpty) {
                  clientList = controller.filteredClientList;
                } else {
                  clientList = controller.clientList;
                }

                return clientList.isNotEmpty
                    ? ListView.builder(
                        itemCount: clientList.length,
                        itemBuilder: (_, index) {
                          final client = clientList[index];

                          return AndroidClientListTile(
                            client: client,
                            onTap: () => controller.clientRegistrationPage(
                                context: context,
                                registrationPage: AndroidClientRegistrationPage(
                                  client: client,
                                )),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Nenhum cliente encontrado'),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
