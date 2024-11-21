import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webview_academia/services/notification_service.dart';
  // Importa sua classe NotificationService

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // A lista de notificações será obtida a partir da classe NotificationService
  late List<String> notifications;

  @override
  void initState() {
    super.initState();

    // Inicializa a lista com as notificações que já foram recebidas
    notifications = NotificationService.instance.getNotifications();

    // Adiciona um listener para quando uma nova notificação for recebida enquanto a tela estiver aberta
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        // Adiciona a notificação recebida à lista
        notifications.add(message.notification?.body ?? 'Sem conteúdo');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Notificações'),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("Nenhuma notificação recebida"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                  onTap: () {
                    // Aqui você pode tratar o que acontece quando o usuário clicar na notificação
                    // ignore: avoid_print
                    print('Notificação clicada: ${notifications[index]}');
                  },
                );
              },
            ),
    );
  }
}
