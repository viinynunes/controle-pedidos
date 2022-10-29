import 'package:flutter/material.dart';

class CustomMaterialBannerError {
  static void showMaterialBannerError(
      {required BuildContext context,
      required String message,
      required VoidCallback onClose}) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Center(child: Text(message)),
        contentTextStyle: _textStyle(),
        backgroundColor: Theme.of(context).errorColor,
        elevation: 10,
        padding: const EdgeInsets.all(8),
        forceActionsBelow: true,
        leading: IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onClose,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 20,),
                  Text(
                    'Recarregar',
                    style: _textStyle(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static _textStyle() {
    return const TextStyle(color: Colors.white);
  }
}
