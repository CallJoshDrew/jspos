import 'package:hive/hive.dart';
import 'package:jspos/models/user.dart';

class CurrentUserStorage {
  static const String _boxName = 'currentUser';

  static Future<void> saveUser(User user) async {
    final box = await Hive.openBox<User>(_boxName);
    await box.put('currentUser', user);
  }

  static Future<User?> getUser() async {
    final box = await Hive.openBox<User>(_boxName);
    return box.get('currentUser');
  }

  static Future<void> clearUser() async {
    final box = await Hive.openBox<User>(_boxName);
    await box.delete('currentUser');
  }
}
