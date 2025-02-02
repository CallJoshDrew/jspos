import 'package:hive/hive.dart';

part 'client_profile.g.dart'; // Import the generated part file

@HiveType(typeId: 5)
class ClientProfile {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String businessRegistrationNumber;
  
  @HiveField(2)
  final String tradingLicense;

  @HiveField(3)
  final String tinNumber;

  @HiveField(4)
  final String address1; // Non-nullable field

  @HiveField(5)
  final String? address2; // Nullable field
  
  @HiveField(6)
  final String? address3; // Nullable field

  @HiveField(7)
  final String postcode;

  @HiveField(8)
  final String state;

  @HiveField(9)
  final String contactNumber;

  @HiveField(10)
  final String? logoPath; // Local path to PNG logo

  ClientProfile({
    this.name = 'Default Name',
    this.businessRegistrationNumber = 'Default BRN',
    this.tradingLicense = 'Default License',
    this.tinNumber = 'Default TIN',
    this.address1 = 'Default Address1',
    this.address2,
    this.address3,
    this.postcode = '00000',
    this.state = 'Default State',
    this.contactNumber = '000-000-0000',
    this.logoPath,
  });
}


  // // Convert a ClientProfile to a Map (for Hive/Supabase)
  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'businessRegistrationNumber': businessRegistrationNumber,
  //     'tinNumber': tinNumber,
  //     'address1': address1,
  //     'address2': address2,
  //     'postcode': postcode,
  //     'state': state,
  //     'contactNumber': contactNumber,
  //     // 'logoPath': logoPath,
  //   };
  // }

  // // Create a ClientProfile from a Map (from Hive/Supabase)
  // factory ClientProfile.fromMap(Map<String, dynamic> map) {
  //   return ClientProfile(
  //     name: map['name'],
  //     businessRegistrationNumber: map['businessRegistrationNumber'],
  //     tinNumber: map['tinNumber'],
  //     address1: map['address1'],
  //     address2: map['address2'],
  //     postcode: map['postcode'],
  //     state: map['state'],
  //     contactNumber: map['contactNumber'],
  //     // logoPath: map['logoPath'],
  //   );
  // }

  // // Convert to JSON for network requests or cloud storage
  // String toJson() => json.encode(toMap());

  // // Create from JSON string
  // factory ClientProfile.fromJson(String source) =>
  //     ClientProfile.fromMap(json.decode(source));

