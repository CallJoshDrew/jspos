import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 6)
class User {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String role;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String activeShiftId;
  @HiveField(5)
  final bool isCheckIn;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.password,
    required this.activeShiftId,
    this.isCheckIn = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? role,
    String? password,
    String? activeShiftId,
    bool? isCheckIn,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      password: password ?? this.password,
      activeShiftId: activeShiftId ?? this.activeShiftId,
      isCheckIn: isCheckIn ?? this.isCheckIn,
    );
  }
}