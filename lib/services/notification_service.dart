import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Variável para armazenar as notificações
List<String> notifications = [];

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<String> initialize() async {
    // Registra o handler de mensagens em segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Solicitar permissão para exibir notificações
    await _requestPermission();

    // Configurar os handlers de mensagens
    await _setupMessageHandlers();

    // Obter o token de FCM para o dispositivo
    final token = await _messaging.getToken();
    // ignore: avoid_print
    print('Token: $token');
    return token ?? '';
  }

  // Solicitar permissão para receber notificações
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // ignore: avoid_print
    print('Status de permissão: ${settings.authorizationStatus}');
  }

  // Configurar o plugin de notificações locais
  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // Configuração do canal de notificação no Android
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      description: 'Este canal é usado para notificações importantes',
      importance: Importance.high,
    );

    // Criar o canal de notificação no Android
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configuração do Android para o inicializador
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração do iOS
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Lógica ao receber uma notificação no iOS
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Inicializar o plugin de notificações locais
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Lógica ao clicar na notificação
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  // Exibir a notificação local no dispositivo
  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Armazena a mensagem recebida
      notifications.add(notification.body ?? 'Sem conteúdo');

      // Exibir a notificação
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notification',
            channelDescription: 'Este canal é usado para notificações importantes',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // Configurar os handlers de mensagens
  Future<void> _setupMessageHandlers() async {
    // Mensagens recebidas enquanto o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Mensagens recebidas enquanto o app está em segundo plano ou fechado
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Recuperando a mensagem inicial, caso o app tenha sido aberto via notificação
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  // Lidar com a mensagem de fundo
  void _handleBackgroundMessage(RemoteMessage message) {
    // Aqui você pode verificar o tipo de mensagem e tomar uma ação
    if (message.data['type'] == 'chat') {
      // Exemplo de navegação ou ação específica
      // ignore: avoid_print
      print('Mensagem de chat recebida!');
    }
  }

  // Método para exibir as notificações armazenadas em uma tela
  List<String> getNotifications() {
    return notifications;
  }
}
