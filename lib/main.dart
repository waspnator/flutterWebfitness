import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_academia/login.dart';
import 'package:flutter_webview_academia/registro.dart';
import 'package:flutter_webview_academia/services/notification_service.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBG9teQ8gJMB_Lq3axongTVogp-yjx4th0',
    appId: '1:264836146924:android:4257020548e47fb1a1a7c9',
    messagingSenderId: '264836146924',
    projectId: 'webviewacademia',
    storageBucket: 'webviewacademia.firebasestorage.app',
  ));
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Webfiness'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo_logo.jpeg'), // Caminho da imagem no diretório assets
            fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o container
          ),
        ),
        child: Column(
          children: <Widget>[
            Column(
              //ROW 1
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 150.0),
                  color: null,
                  child: Image.asset(
                    'assets/power-gym.png',
                    height: 250,
                    width: 250,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Muda a cor do texto do botão
                          backgroundColor: Colors.orange, // Muda a cor de fundo do botão
                        ),
                        child: const Text("Login"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 8.0),
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CadastroScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Muda a cor do texto do botão
                          backgroundColor: Colors.orange, // Muda a cor de fundo do botão
                        ),
                        child: const Text("Cadastro"),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _validateContent() async {
    // ignore: deprecated_member_use
    String content = await _controller.evaluateJavascript("document.body.innerText");
    if (content.contains("Expected Text")) {
      // ignore: avoid_print
      print("Content is valid");
    } else {
      // ignore: avoid_print
      print("Content is not valid");
    }
  }
}
