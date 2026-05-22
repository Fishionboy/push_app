import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMesagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    //TODO 3: Crear el listener # _onPushMessageReceived

    //Verificar estado de las notificaciones
    _initialStatusCheck();
    //Listener para notificaciones en foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async{

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  void _notificationStatusChanged(NotificationsStatusChanged event,Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }
  
  void _onPushMessageReceived(NotificationReceived event,Emitter<NotificationsState> emit){
    emit(
      state.copyWith(
       notifications: [event.pushMessage, ...state.notifications]
      )
    );   
  }

  void _initialStatusCheck () async{
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
    _getFCMToken();
  }

  void _getFCMToken () async{
    
    if ( state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId: message.messageId
      ?.replaceAll(':', '').replaceAll('%', '') 
      ?? '', 
      title: message.notification!.title ?? '', 
      body: message.notification!.body ?? '', 
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl 
        : message.notification!.apple?.imageUrl 
      );

      add(NotificationReceived(notification));
  }

  void _onForegroundMessage(){
   FirebaseMessaging.onMessage.listen(_handleRemoteMessage);   
  }

  void requestPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: true,
  provisional: false,
  sound: true,
);

add(NotificationsStatusChanged(settings.authorizationStatus));
  }
}
