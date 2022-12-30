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
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (context) {
            return Text(controller.user?.company.name ?? 'COMPANY');
          }
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

              ],
            ),
          ),
        ),
      ),
    );
  }
}
