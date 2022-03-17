import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  ReviewBloc({required this.reviewRepository}) : super(ReviewSending());

  @override
  Stream<ReviewState> mapEventToState(ReviewEvent event) async* {
    if (event is ReviewCreate) {
      yield ReviewSending();
      try {
        await reviewRepository.createReview(event.review);
        yield ReviewSent();
      } catch (_) {
        yield ReviewSendingFailure();
      }
    }
  }
}

class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReviewCreate extends ReviewEvent {
  final Review review;
  const ReviewCreate(this.review);
  @override
  List<Object?> get props => [review];
  @override
  String toString() => 'Review Created {user: $review}';
}

class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewSending extends ReviewState {}

class ReviewSent extends ReviewState {}

class ReviewSendingFailure extends ReviewState {}
