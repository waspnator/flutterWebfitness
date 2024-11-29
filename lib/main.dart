import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_academia/NotificationScreen.dart';
import 'package:flutter_webview_academia/login.dart';
import 'package:flutter_webview_academia/registro.dart';
import 'package:flutter_webview_academia/services/notification_service.dart';

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
   return MaterialApp(
      // Definindo a rota inicial e as rotas nomeadas
      initialRoute: '/',
      routes: {
        '/': (context) => const WebViewExample(),
        '/login': (context) => const Login(),
        '/cadastro': (context) => const CadastroScreen(),
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Gestão Fitness'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Ao clicar no ícone de notificação, navega para a tela de notificações
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundo_logo.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 150.0),
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
                          Navigator.pushNamed(
                            context,
                            '/login', // Usando a rota nomeada
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
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
                          Navigator.pushNamed(
                            context,
                            '/cadastro', // Usando a rota nomeada
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
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
}
