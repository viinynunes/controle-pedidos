import 'package:controle_pedidos/src/core/admob/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../../core/widgets/show_entity_selection_dialog.dart';
import '../../../../../../domain/entities/provider.dart';
import '../../../stores/product_registration_controller.dart';
import '../../i_product_registration_page.dart';

class AndroidProductRegistrationPage extends IProductRegistrationPage {
  const AndroidProductRegistrationPage({super.key, super.product});

  @override
  State<StatefulWidget> createState() => _AndroidProductRegistrationPageState();
}

class _AndroidProductRegistrationPageState
    extends IProductRegistrationPageState<AndroidProductRegistrationPage,
        ProductRegistrationController> {
  final adHelper = AdMobHelper();

  @override
  void initState() {
    super.initState();

    reaction((_) => controller.error, (_) {
      controller.error.map((error) => showError(message: error.message));
    });

    reaction((_) => controller.success, (_) {
      controller.success
          .map((_) => showSuccess(message: 'Produto salvo com sucesso'));
    });

    adHelper.createRewardedAd();

    controller.initState(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.newProduct
            ? 'Novo Produto'
            : controller.nameController.text),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: controller.clearFields,
              icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.saveOrUpdate(context),
        child: const Icon(Icons.save),
      ),
      body: WillPopScope(
        onWillPop: () async {
          adHelper.showRewardedAd();

          return true;
        },
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: controller.nameController,
                        focus: controller.nameFocus,
                        label: 'Nome',
                        validator: controller.nameValidator,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: controller.categoryController,
                        label: 'Embalagem',
                        maxLength: 3,
                        validator: controller.categoryValidator,
                      ),
                      const SizedBox(height: 20),
                      const Text('Fornecedor'),
                      Observer(
                        builder: (_) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final selected = await showDialog(
                                  context: context,
                                  builder: (_) => ShowEntitySelectionDialog(
                                        entityList: controller.providerList,
                                      ));

                              if (selected is Provider) {
                                controller.selectProvider(selected);
                              }
                            },
                            child: controller.loading
                                ? const LinearProgressIndicator()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        controller.selectedProvider
                                                ?.toString() ??
                                            '',
                                      ),
                                      const Icon(Icons.search)
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Ativo'),
                      Observer(
                        builder: (_) => Switch(
                            value: controller.enabled,
                            onChanged: (_) => controller.changeEnabled()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
