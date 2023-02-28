import 'package:controle_pedidos/src/core/admob/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../core/admob/widgest/banner_ad_widget.dart';
import '../../../../../core/ui/states/base_state.dart';
import '../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../../../../domain/entities/provider.dart';
import '../../stores/provider_controller.dart';
import 'android_provider_registration_page.dart';
import 'tiles/android_provider_list_tile.dart';

class AndroidProviderListPage extends StatefulWidget {
  const AndroidProviderListPage({Key? key}) : super(key: key);

  @override
  State<AndroidProviderListPage> createState() =>
      _AndroidProviderListPageState();
}

class _AndroidProviderListPageState
    extends BaseState<AndroidProviderListPage, ProviderController> {
  final adHelper = AdMobHelper();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    adHelper.createRewardedAd();
    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
        onPressed: () => controller.callProviderRegistrationPage(
            context: context,
            registrationPage: const AndroidProviderRegistrationPage()),
        child: const Icon(Icons.add),
      ),
      body: WillPopScope(
        onWillPop: () async {
          adHelper.showRewardedAd();

          return true;
        },
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: Observer(
                    builder: (_) {
                      List<Provider> providerList = [];

                      if (controller.loading) {
                        return ShimmerListBuilder(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: double.maxFinite,
                            itemCount: 10);
                      }

                      if (controller.searching &&
                          controller.searchText.isNotEmpty) {
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
                                            context: context,
                                            registrationPage:
                                                AndroidProviderRegistrationPage(
                                              provider: provider,
                                            )));
                              },
                            )
                          : const Center(
                              child: Text('Nenhum fornecedor encontrado'),
                            );
                    },
                  ),
                ),
                BannerAdWidget(
                  showAd: controller.showBannerAd(),
                  width: size.width,
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
