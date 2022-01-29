import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildBackgroud() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        stops: [
          -0.098,
          0.015,
          0.12,
          0.90,
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xFF19293e),
          Color(0xFF030f12),
          Color(0xFF10231f),
          Color(0xFF31648c),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroud(),
          Form(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(
                  height: 150,
                ),
                const Text(
                  'Realize o login',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Icon(
                  Icons.water_damage_outlined,
                  size: 150,
                  color: Colors.white,
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Usuário',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Senha',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 25),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: const BorderSide(color: Colors.black)
                            )
                        )
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
