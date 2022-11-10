import 'package:controle_pedidos/src/modules/core/home/stores/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AndroidHomePage extends StatelessWidget {
  const AndroidHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<HomePageController>();

    return Scaffold(
      body: Observer(
        builder: (_) => controller.bottomNavigationElements
            .elementAt(controller.bottomNavigationIndex),
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
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_task_outlined,
              ),
              label: ''
            ),
          ],
          onTap: (index) {
            controller.bottomNavigationIndex = index;
          },
        ),
      ),
    );
  }
}
