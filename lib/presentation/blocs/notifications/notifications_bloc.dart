import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/config/domain/entities/push_message.dart';

import 'package:push_app/firebase_options.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    //Verificas estado de las notificaciones
    on<NotifationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);
    _initialStatusCheck();
    //Listener foreground
    _onForegroundMessage();

    _handleInitialMessage();

    //TODO 3: Crear el listener _onPushMessageReceived()
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(NotifationStatusChanged event,Emitter<NotificationsState> emit) {
    emit(
        state.copyWith(status: event.status
      ));
    _getFCMToken();
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(
        state.copyWith(
          notifications: [event.message,... state.notifications]
      ));   
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotifationStatusChanged(settings.authorizationStatus));
    _getFCMToken();
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      handleRemoteMessage(message);
    }
  }
 
  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.title ?? '',
      sendDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    add(NotificationReceived(notification));
  }



  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    add(NotifationStatusChanged(settings.authorizationStatus));
  }
  
  PushMessage? getMessageById(String pushMessageId){
    final exist = state.notifications.any((element)=> element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications.firstWhere((element)=> element.messageId == pushMessageId);
  }
}
