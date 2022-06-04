import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/cubit/favorite_location_state.dart';
import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/repository/repositories.dart';

class FavoriteLocationCubit extends Cubit<FavoriteLocationState> {
  final DataBaseHelperRepository favoriteLocationRepository;
  FavoriteLocationCubit({required this.favoriteLocationRepository})
      : super(FavoriteLocationLoading());

  void getFavoriteLocations() async {
    emit(FavoriteLocationLoading());
    final data = await favoriteLocationRepository.getFavoriteData();
    emit(FavoriteLocationLoadSuccess(savedLocation: data));
  }

  void addToFavoriteLocation(SavedLocation location) async {
    emit(FavoriteLocationLoading());
    final data =
        await favoriteLocationRepository.inserToFavoriteDatabase(location);
    emit(FavoriteLocationLoadSuccess(savedLocation: data));
  }

  void clearFavoriteLocations() async {
    emit(FavoriteLocationLoading());
    try {
      await favoriteLocationRepository.clearLocations();
    } catch (_) {
      emit(FavoriteLocationOperationSuccess());
    }
  }

  void updateFavoriteLocation(SavedLocation location) async {
    emit(FavoriteLocationLoading());
    await favoriteLocationRepository.updateLocation(location);
    emit(FavoriteLocationOperationSuccess());
  }

  void deleteFavoriteLocation(int id) async {
    await favoriteLocationRepository.deleteLocation(id);
  }

  void deleteFavoriteLocationByPlaceId(String placeId) async {
    emit(FavoriteLocationLoading());
    final data =
        await favoriteLocationRepository.deleteLocationByPlaceID(placeId);
    emit(FavoriteLocationLoadSuccess(savedLocation: data));
  }
}
