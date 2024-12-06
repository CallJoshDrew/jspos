import 'package:jspos/utils/user_utils.dart';

final List<Map<String, dynamic>> users = [
  {"id": "1", "name": "Fanny", "role": "cashier", "password": '888'},
  {"id": "2", "name": "Henry", "role": "cashier", "password": '999'},
  // {"id": "3", "name": "San", "role": "cashier", "password": '777'},
];

final userList = mapToUserList(users);