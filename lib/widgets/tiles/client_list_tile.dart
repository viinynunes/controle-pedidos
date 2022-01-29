import 'package:controle_pedidos/data/client_data.dart';
import 'package:controle_pedidos/pages/client/client_registration_page.dart';
import 'package:flutter/material.dart';

class ClientListTile extends StatelessWidget {
  const ClientListTile({Key? key, required this.client}) : super(key: key);

  final ClientData client;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (e){},
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete_forever, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      movementDuration: const Duration(seconds: 3),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ClientRegistrationPage(client: client,)));
        },
        child: Card(
            child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    client.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Icon(Icons.edit),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
