import 'package:controle_pedidos/src/core/admob/widgest/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/admob/admob_helper.dart';
import '../../../../../../core/ui/states/base_state.dart';
import '../../../../../../core/widgets/shimmer/shimmer_list_builder.dart';
import '../../../stores/product_controller.dart';
import 'android_product_registration_page.dart';
import 'tiles/android_product_list_tile.dart';

class AndroidProductListPage extends StatefulWidget {
  const AndroidProductListPage({Key? key}) : super(key: key);

  @override
  State<AndroidProductListPage> createState() => _AndroidProductListPageState();
}

class _AndroidProductListPageState
    extends BaseState<AndroidProductListPage, ProductController> {


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
                    decoration:
                        const InputDecoration(hintText: 'Pesquisar Produto'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (text) {
                      controller.searchText = text;
                      controller.filterProductListByText();
                    },
                    keyboardType: TextInputType.url,
                  )
                : const Text('Produtos')),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => controller.searching
                ? IconButton(
                    onPressed: () {
                      controller.searching = false;
                      controller.searchText = '';
                      controller.getProductList();
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
              onPressed: controller.getProductList,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.callProductRegistrationPage(
            context: context,
            registrationPage: const AndroidProductRegistrationPage()),
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
                  child: Observer(builder: (_) {
                    var productList = [];

                    if (controller.loading) {
                      return ShimmerListBuilder(
                        itemCount: 30,
                        height: size.height * 0.05,
                        width: double.maxFinite,
                      );
                    }

                    if (controller.searching &&
                        controller.searchText.isNotEmpty) {
                      productList = controller.filteredProductList;
                    } else {
                      productList = controller.productList;
                    }

                    return productList.isNotEmpty
                        ? ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (_, index) {
                              final product = productList[index];

                              return AndroidProductListTile(
                                  product: product,
                                  onTap: () =>
                                      controller.callProductRegistrationPage(
                                          context: context,
                                          registrationPage:
                                              AndroidProductRegistrationPage(
                                                  product: product)));
                            },
                          )
                        : const Center(
                            child: Text('Nenhum produto encontrado'),
                          );
                  }),
                ),
                BannerAdWidget(
                  showAd: controller.showAds(),
                  height: size.height * .1,
                  width: size.width,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
