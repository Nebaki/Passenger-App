import 'package:passengerapp/dataprovider/dataproviders.dart';
import 'package:passengerapp/models/models.dart';

class CategoryRepository {
  final CategoryDataProvider categoryDataProvider;
  const CategoryRepository({required this.categoryDataProvider});
  Future<List<Category>> getCategories() async {
    return await categoryDataProvider.getCategories();
  }
}
