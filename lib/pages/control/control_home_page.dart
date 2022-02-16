import 'package:controle_pedidos/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControlHomePage extends StatefulWidget {
  const ControlHomePage({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _ControlHomePageState createState() => _ControlHomePageState();
}

class _ControlHomePageState extends State<ControlHomePage> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late DateTime iniDate, endDate;

  @override
  void initState() {
    super.initState();

    iniDate = DateTime.now();
    endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        pageController: widget.pageController,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: iniDate,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2050))
                            .then((value) {
                          setState(() {
                            if (value != null) {
                              iniDate = value;
                            }
                          });
                        });
                      },
                      child: Text(dateFormat.format(iniDate))),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2050))
                            .then((value) {
                          setState(() {
                            if (value != null) {
                              endDate = value;
                            }
                          });
                        });
                      },
                      child: Text(dateFormat.format(endDate))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Carregar Fornecedores'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
