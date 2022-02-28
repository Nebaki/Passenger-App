import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';

class NotificationRequestBloc
    extends Bloc<NotificationRequestEvent, NotificationRequestState> {
  final NotificationRequestRepository notificationRequestRepository;
  NotificationRequestBloc({required this.notificationRequestRepository})
      : super(NotificationRequestSending());

  @override
  Stream<NotificationRequestState> mapEventToState(
      NotificationRequestEvent event) async* {
    if (event is NotificationRequestSend) {
      yield NotificationRequestSending();
      try {
        await notificationRequestRepository.sendNotification(event.request);
        yield NotificationRequestSent();
      } catch (_) {
        yield NotificationRequestSendingFailure();
      }
    }
  }
}

class NotificationRequestEvent extends Equatable {
  const NotificationRequestEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NotificationRequestSend extends NotificationRequestEvent {
  final NotificationRequest request;
  const NotificationRequestSend(this.request);
  @override
  List<Object?> get props => [request];
  @override
  String toString() => 'Request Created {user: $request}';
}

class NotificationRequestState extends Equatable {
  const NotificationRequestState();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NotificationRequestSending extends NotificationRequestState {}

class NotificationRequestSent extends NotificationRequestState {}

class NotificationRequestSendingFailure extends NotificationRequestState {}
