import 'package:controle_pedidos/src/modules/core/drawer/widgets/android_custom_drawer.dart';
import 'package:controle_pedidos/src/modules/core/widgets/custom_material_banner_error.dart';
import 'package:controle_pedidos/src/modules/product/presenter/pages/android/pages/tiles/android_provider_list_tile.dart';
import 'package:controle_pedidos/src/modules/product/presenter/stores/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'android_product_registration_page.dart';

class AndroidProductListPage extends StatefulWidget {
  const AndroidProductListPage({Key? key}) : super(key: key);

  @override
  State<AndroidProductListPage> createState() => _AndroidProductListPageState();
}

class _AndroidProductListPageState extends State<AndroidProductListPage> {
  final controller = GetIt.I.get<ProductController>();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error
          .map((error) => CustomMaterialBannerError.showMaterialBannerError(
              context: context,
              message: error.message,
              onClose: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                controller.getProductList();
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
                    decoration:
                        const InputDecoration(hintText: 'Pesquisar Produto'),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (text) {
                      controller.searchText = text;
                      controller.filterProductListByText();
                    },
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
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Observer(builder: (_) {
            var productList = [];

            if (controller.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.searching && controller.searchText.isNotEmpty) {
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
                          onTap: () => controller.callProductRegistrationPage(
                              context: context,
                              registrationPage: AndroidProductRegistrationPage(
                                  product: product)));
                    },
                  )
                : const Center(
                    child: Text('Nenhum produto encontrado'),
                  );
          }),
        ),
      ),
    );
  }
}
