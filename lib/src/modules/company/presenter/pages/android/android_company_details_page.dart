import 'package:controle_pedidos/src/modules/company/presenter/stores/company_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AndroidCompanyDetailsPage extends StatefulWidget {
  const AndroidCompanyDetailsPage({Key? key}) : super(key: key);

  @override
  State<AndroidCompanyDetailsPage> createState() =>
      _AndroidCompanyDetailsPageState();
}

class _AndroidCompanyDetailsPageState extends State<AndroidCompanyDetailsPage> {
  final controller = GetIt.I.get<CompanyDetailsController>();

  @override
  void initState() {
    controller.getLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,
              height: size.height * .2,
              padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor),
              child: Observer(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.user?.company.name ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.logout();
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Theme.of(context).indicatorColor,
                            ))
                      ],
                    ),
                    Expanded(
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.user?.email ?? ''),
                          Text(controller.user?.fullName ?? ''),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.monetization_on),
              title: const Text('Assinatura'),
              trailing: Observer(builder: (context) {
                return Text(
                    controller.user?.company.subscription.name ?? '');
              }),
            ),
          ],
        ),
      ),
    );
  }
}
