part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();

}

class NotifationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotifationStatusChanged(this.status);
}

class NotificationReceived extends NotificationsEvent{
  final PushMessage message;

  NotificationReceived(this.message);
}

