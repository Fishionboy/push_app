part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();  
}

class NotificationsStatusChanged extends NotificationsEvent{
  final AuthorizationStatus status;

  const NotificationsStatusChanged(this.status);
  
 
  
}

//Todo 2 NotivicationReceived #PUshMessage
class NotificationReceived extends NotificationsEvent{
  final PushMessage pushMessage;

  NotificationReceived(this.pushMessage);

}