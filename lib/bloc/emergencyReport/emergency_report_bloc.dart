import 'package:passengerapp/repository/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmergencyReportBloc
    extends Bloc<EmergencyReportEvent, EmergencyReportState> {
  final EmergencyReportRepository emergencyReportRepository;

  EmergencyReportBloc({required this.emergencyReportRepository})
      : super(EmergencyReportCreating());

  @override
  Stream<EmergencyReportState> mapEventToState(
      EmergencyReportEvent event) async* {
    if (event is EmergencyReportCreate) {
      yield EmergencyReportCreating();
      try {
        await emergencyReportRepository
            .createEmergencyReport(event.emergencyReport);
        yield EmergencyReportCreated();
      } catch (_) {
        yield EmergencyReportOperationFailur();
      }
    }
  }
}

class EmergencyReportEvent extends Equatable {
  const EmergencyReportEvent();
  @override
  List<Object?> get props => [];
}

class EmergencyReportCreate extends EmergencyReportEvent {
  final EmergencyReport emergencyReport;

  const EmergencyReportCreate(this.emergencyReport);
  @override
  List<Object> get props => [emergencyReport];

  @override
  String toString() => 'Report Created {user: $emergencyReport}';
}

class EmergencyReportState extends Equatable {
  const EmergencyReportState();
  @override
  List<Object?> get props => [];
}

class EmergencyReportCreating extends EmergencyReportState {}

class EmergencyReportCreated extends EmergencyReportState {}

class EmergencyReportOperationFailur extends EmergencyReportState {}
