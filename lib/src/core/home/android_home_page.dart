import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../widgets/custom_material_banner_error.dart';
import 'stores/home_page_controller.dart';

class AndroidHomePage extends StatefulWidget {
  const AndroidHomePage({Key? key}) : super(key: key);

  @override
  State<AndroidHomePage> createState() => _AndroidHomePageState();
}

class _AndroidHomePageState extends State<AndroidHomePage> {
  final controller = GetIt.I.get<HomePageController>();

  @override
  void initState() {
    super.initState();

    reaction((p0) => controller.productError, (p0) {
      controller.productError.map((error) =>
          CustomMaterialBannerError.showMaterialBannerError(
              context: context,
              message: error.message,
              onClose: () => controller.getProductListByEnabled()));
    });

    reaction((p0) => controller.clientError, (p0) {
      controller.clientError.map((error) =>
          CustomMaterialBannerError.showMaterialBannerError(
              context: context,
              message: error.message,
              onClose: () => controller.getProductListByEnabled()));
    });

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => controller.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PageView(
                controller: controller.pageController,
                onPageChanged: controller.changeIndex,
                children: controller.getBottomNavigationElements(),
              ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          currentIndex: controller.bottomNavigationIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.reorder,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_task_outlined,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_chart_outlined,
                ),
                label: ''),
          ],
          onTap: (index) {
            controller.changeIndex(index);
            controller.pageController.animateToPage(
                controller.bottomNavigationIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear);
          },
        ),
      ),
    );
  }
}
