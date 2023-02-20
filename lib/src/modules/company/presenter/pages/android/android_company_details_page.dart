import 'package:controle_pedidos/src/modules/company/presenter/stores/company_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

  _showCompanySubscriptionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: const Center(
          child: Text('Planos'),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                ListTile(
                  onTap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Free'),
                      Text('Gratis')
                    ],
                  ),
                  subtitle: const AutoSizeText(
                    'Plano gratuito onde é possivel utilizar o sistema, porém anuncios são exibidos com frequencia',
                    maxLines: 4,
                    minFontSize: 5,
                  ),
                ),
                const Divider(),
                ListTile(
                  onTap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Basic'),
                      Text(r'R$14,90')
                    ],
                  ),
                  subtitle: const AutoSizeText(
                    'Plano sem anuncios, é possivel utilizar o sistema sem nenhuma interrupção por anuncios',
                    maxLines: 4,
                    minFontSize: 5,
                  ),
                ),
                const Divider(),
                Visibility(
                  visible: false,
                  child: ListTile(
                    onTap: () {},
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Premium'),
                        Text(r'R$24,90')
                      ],
                    ),
                    subtitle: const AutoSizeText(
                      'Plano premium é possivel utilizar o sistema, porém anuncios são exibidos com frequencia',
                      maxLines: 4,
                      minFontSize: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              height: size.height * .3,
              padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
              decoration:
                  BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
              child: Observer(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          controller.user?.company.name ?? '',
                          maxLines: 1,
                          minFontSize: 5,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.logout();
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Theme.of(context).colorScheme.secondary,
                            ))
                      ],
                    ),
                    Expanded(
                      child: Column(
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            controller.user?.email ?? '',
                            minFontSize: 5,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            controller.user?.fullName ?? '',
                            minFontSize: 5,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
            ListTile(
              onTap: () {
                _showCompanySubscriptionDialog();
              },
              leading: const Icon(Icons.monetization_on),
              title: const Text('Assinatura'),
              trailing: Observer(builder: (context) {
                return Text(controller.user?.company.subscription.name ?? '');
              }),
            ),
          ],
        ),
      ),
    );
  }
}
