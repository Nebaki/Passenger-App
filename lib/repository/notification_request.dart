import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class NotificationRequestRepository {
  final NotificationRequestDataProvider dataProvider;

  NotificationRequestRepository({required this.dataProvider});

  Future sendNotification(NotificationRequest request) async {
    return await dataProvider.sendNotification(request);
  }
}
