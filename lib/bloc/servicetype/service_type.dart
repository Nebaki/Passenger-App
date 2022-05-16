import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passengerapp/models/models.dart';

abstract class SelectedCategoryEvent extends Equatable {
  const SelectedCategoryEvent();
}

class SelectCategory extends SelectedCategoryEvent {
  final Category category;
  const SelectCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class SelectedCategoryState extends Equatable {
  @override
  List<Object?> get props => [];
  const SelectedCategoryState();
}

class SelectedCategoryLoading extends SelectedCategoryState {}

class CategoryChanged extends SelectedCategoryState {
  final Category category;
  const CategoryChanged(this.category);
  @override
  List<Object?> get props => [category];
}

class SelectedCategoryOperationFailure extends SelectedCategoryState {}

class SelectedCategoryBloc
    extends Bloc<SelectedCategoryEvent, SelectedCategoryState> {
  SelectedCategoryBloc(SelectedCategoryState initialState)
      : super(initialState);

  @override
  Stream<SelectedCategoryState> mapEventToState(
      SelectedCategoryEvent event) async* {
    if (event is SelectCategory) {
      yield SelectedCategoryLoading();
      try {
        yield CategoryChanged(event.category);
      } catch (e) {
        yield SelectedCategoryOperationFailure();
      }
    }
  }
}
