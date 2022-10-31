import 'package:controle_pedidos/src/modules/core/drawer/widgets/android_custom_drawer.dart';
import 'package:controle_pedidos/src/modules/core/widgets/custom_material_banner_error.dart';
import 'package:controle_pedidos/src/modules/provider/domain/entities/provider.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/android/pages/tiles/android_provider_list_tile.dart';
import 'package:controle_pedidos/src/modules/provider/presenter/stores/provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class AndroidProviderListPage extends StatefulWidget {
  const AndroidProviderListPage({Key? key}) : super(key: key);

  @override
  State<AndroidProviderListPage> createState() =>
      _AndroidProviderListPageState();
}

class _AndroidProviderListPageState extends State<AndroidProviderListPage> {
  final controller = GetIt.I.get<ProviderController>();

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
                controller.getProviderList();
              }));
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AndroidCustomDrawer(),
      appBar: AppBar(
        title: Observer(
          builder: (_) => controller.searching
              ? TextField(
                  focusNode: controller.searchFocus,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (text) {
                    controller.searchText = text;
                    controller.filterProviderListByText();
                  },
                )
              : const Text('Fornecedores'),
        ),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.searching
                ? IconButton(
                    onPressed: () {
                      controller.searching = false;
                      controller.getProviderList();
                    },
                    icon: const Icon(Icons.close),
                  )
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
        onPressed: () =>
            controller.callProviderRegistrationPage(context: context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Observer(
            builder: (_) {
              List<Provider> providerList = [];

              if (controller.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.searching && controller.searchText.isNotEmpty) {
                providerList = controller.filteredProviderList;
              } else {
                providerList = controller.providerList;
              }
              return providerList.isNotEmpty
                  ? ListView.builder(
                      itemCount: providerList.length,
                      itemBuilder: (_, index) {
                        final provider = providerList[index];
                        return AndroidProviderListTile(
                            provider: provider,
                            onTap: () =>
                                controller.callProviderRegistrationPage(
                                    context: context, provider: provider));
                      },
                    )
                  : const Center(
                      child: Text('Nenhum fornecedor encontrado'),
                    );
            },
          ),
        ),
      ),
    );
  }
}
