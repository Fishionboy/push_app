part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();

}

class NotifationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotifationStatusChanged(this.status);
}
