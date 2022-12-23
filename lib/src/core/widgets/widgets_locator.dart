import 'package:get_it/get_it.dart';

import 'stores/show_entity_selection_dialog_controller.dart';

final widgetsLocator = GetIt.instance;

void setUpWidgetsLocator() {
  widgetsLocator.registerFactory<ShowEntitySelectionDialogController>(
      () => ShowEntitySelectionDialogController());
}
