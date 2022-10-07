import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';
import 'package:passengerapp/utils/session.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository}) : super(CategoryLoading());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    Session().logSession("cat-event", "happened");
    if (event is CategoryLoad) {
      yield CategoryLoading();

      try {
        List<Category> categories = await categoryRepository.getCategories();
        yield CategoryLoadSuccess(categories: categories);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield CategoryUnAuthorised();
        } else {
          Session().logSession("cat-error", e.toString());
          yield (CategoryOperationFailure());
        }
        yield CategoryOperationFailure();
      }
    }
  }
}

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryLoad extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<Category> categories;
  const CategoryLoadSuccess({required this.categories});
  @override
  List<Object?> get props => categories;
}

class CategoryOperationFailure extends CategoryState {}

class CategoryUnAuthorised extends CategoryState {}
