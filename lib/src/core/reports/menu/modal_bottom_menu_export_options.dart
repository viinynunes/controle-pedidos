import 'package:flutter/material.dart';

class ModalBottomMenuExportOptions extends StatelessWidget {
  const ModalBottomMenuExportOptions(
      {Key? key, this.onGenerateImage, this.onGeneratePDF, this.onGenerateXLSX})
      : super(key: key);

  final VoidCallback? onGenerateImage;
  final VoidCallback? onGeneratePDF;
  final VoidCallback? onGenerateXLSX;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            onGenerateImage != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onGenerateImage,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image,
                            ),
                          ],
                        ),
                        title: const Text('Gerar Imagem'),
                        subtitle: const Text('Gera uma imagem em formato PNG'),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            onGeneratePDF != null
                ? Column(
                    children: [
                      ListTile(
                        onTap: onGeneratePDF,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.picture_as_pdf,
                            ),
                          ],
                        ),
                        title: const Text('Gerar PDF'),
                        subtitle: const Text('Gera um arquivo em formato PDF'),
                      ),
                      const Divider(),
                    ],
                  )
                : Container(),
            onGenerateXLSX != null
                ? ListTile(
                    onTap: onGenerateXLSX,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.file_present,
                        ),
                      ],
                    ),
                    title: const Text('Gerar XLSX'),
                    subtitle:
                        const Text('Gera um arquivo em formato XLSX (Excel)'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
