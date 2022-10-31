import 'package:controle_pedidos/src/modules/core/widgets/stores/show_entity_selection_dialog_controller.dart';
import 'package:get_it/get_it.dart';

final widgetsLocator = GetIt.instance;

void setUpWidgetsLocator() {
  widgetsLocator.registerFactory<ShowEntitySelectionDialogController>(
      () => ShowEntitySelectionDialogController());
}
