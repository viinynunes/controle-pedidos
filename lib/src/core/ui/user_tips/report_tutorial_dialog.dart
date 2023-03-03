import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TipsDialog extends StatefulWidget {
  const TipsDialog(
      {super.key,
      this.title = 'Dicas',
      required this.message,
      required this.onDontShowAgain});

  final String title;
  final String message;
  final VoidCallback onDontShowAgain;

  @override
  State<TipsDialog> createState() => _TipsDialogState();
}

class _TipsDialogState extends State<TipsDialog> {
  bool disableTip = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Center(child: Text(widget.title)),
      content: SizedBox(
        height: size.height * .4,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                    value: disableTip,
                    onChanged: (e) {
                      setState(() {
                        disableTip = e!;
                      });
                    }),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: AutoSizeText(
                    'Não exibir esta dica novamente',
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(
              width: size.width * .6,
              child: ElevatedButton(
                onPressed: () {
                  if (disableTip) {
                    widget.onDontShowAgain();
                  }
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
