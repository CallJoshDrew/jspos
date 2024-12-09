import 'package:jspos/models/client_profile.dart';

ClientProfile mapToClientProfile(Map<String, dynamic> map) {
  return ClientProfile(
    name: map['name'] as String,
    businessRegistrationNumber: map['businessRegistrationNumber'] as String,
    tinNumber: map['tinNumber'] as String,
    address1: map['address1'] as String,
    address2: map['address2'] as String?,
    postcode: map['postcode'] as String,
    state: map['state'] as String,
    contactNumber: map['contactNumber'] as String,
    logoPath: map['logoPath'] as String?,
  );
}

Map<String, dynamic> clientProfileToMap(ClientProfile profile) {
  return {
    'name': profile.name,
    'businessRegistrationNumber': profile.businessRegistrationNumber,
    'tinNumber': profile.tinNumber,
    'address1': profile.address1,
    'address2': profile.address2,
    'postcode': profile.postcode,
    'state': profile.state,
    'contactNumber': profile.contactNumber,
    'logoPath': profile.logoPath,
  };
}
