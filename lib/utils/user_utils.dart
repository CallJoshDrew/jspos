import 'package:jspos/models/user.dart';

List<User> mapToUserList(List<Map<String, dynamic>> rawUsers) {
  return rawUsers.map((user) {
    return User(
      id: user['id'] as String,
      name: user['name'] as String,
      role: user['role'] as String,
      password: user['password'] as String,
      activeShiftId: 'activeID'
    );
  }).toList();
}

