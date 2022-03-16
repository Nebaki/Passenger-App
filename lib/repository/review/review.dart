import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class ReviewRepository {
  final ReviewDataProvider dataProvider;
  ReviewRepository({required this.dataProvider});
  Future<void> createReview(Review review) async {
    return await dataProvider.createRideRequest(review);
  }
}
