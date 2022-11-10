import 'package:controle_pedidos/src/modules/core/home/stores/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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

    controller.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.changeIndex,
        children: controller.bottomNavigationElements,
      ),
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          currentIndex: controller.bottomNavigationIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.border_color,
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
