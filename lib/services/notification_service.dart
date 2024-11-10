import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}


class NotificationService{
  
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  // ignore: non_constant_identifier_names
  final _local_notifications = FlutterLocalNotificationsPlugin();
  // ignore: non_constant_identifier_names
  bool _isflutter_local_notificationsInitialized = false;

  Future<String> initialize() async {
 
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //Request permission
    await _requestPermission();

    //Setup message handlers
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    print('Token: $token');
    return token.toString();
  }

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

    print('permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isflutter_local_notificationsInitialized){
      return;
    }

    //android  setup
    const channel = AndroidNotificationChannel('high_importance_chanel', 
    'High Importance Notification',
    description: 'This channel is used for important notifications',
    importance:  Importance.high,
    );

    await _local_notifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher'); 

    //ios setup
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        //
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _local_notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        
      },
    );

    _isflutter_local_notificationsInitialized = true;
  }

  Future<void> showNotification (RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
   
    if(notification != null && android != null){
      await _local_notifications.show(
        notification.hashCode, 
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_chanel', 
            'High Importance Notification',
            channelDescription: 'This channel is used for important notifications',
            importance:  Importance.high,
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

  Future<void> _setupMessageHandlers() async {
    //foreground message

    FirebaseMessaging.onMessage.listen((message){
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    //opened app
    final initialMessage = await _messaging.getInitialMessage();
    if(initialMessage != null){
      _handleBackgroundMessage(initialMessage);
    }

  }

  void _handleBackgroundMessage(RemoteMessage message){
    if(message.data['type'] == 'chat'){

    }
  }

}