import 'package:hive/hive.dart';

class CategoryController {
  static void setCategories(List<String> categories) async {
    var box = Hive.box('categories');
    await box.put('categories', categories.join(','));
  }

  static List<String> getCategories() {
    var box = Hive.box('categories');
    var categories = box.get('categories') ?? "Cakes,Dishes,Drinks";
    return categories.split(',');
  }
}
