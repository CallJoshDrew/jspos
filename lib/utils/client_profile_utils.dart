import 'package:jspos/models/client_profile.dart';

ClientProfile mapToClientProfile(Map<String, dynamic> data) {
  return ClientProfile(
    name: data['name'] as String? ?? 'Default Name',
    businessRegistrationNumber: data['businessRegistrationNumber'] as String? ?? 'Default BRN',
    tradingLicense: data['tradingLicense'] as String? ?? 'Default License',
    tinNumber: data['tinNumber'] as String? ?? 'Default TIN',
    address1: data['address1'] as String? ?? 'Default Address1',
    address2: data['address2'] as String? ?? 'Default Address2',
    address3: data['address3'] as String? ?? 'Default Address3',
    postcode: data['postcode'] as String? ?? '00000',
    state: data['state'] as String? ?? 'Default State',
    contactNumber: data['contactNumber'] as String? ?? '000-000-0000',
    logoPath: data['logoPath'] as String? ?? 'Default Logo Path',
  );
}

Map<String, dynamic> clientProfileToMap(ClientProfile profile) {
  return {
    'name': profile.name,
    'businessRegistrationNumber': profile.businessRegistrationNumber,
    'tradingLicense' : profile.tradingLicense,
    'tinNumber': profile.tinNumber,
    'address1': profile.address1,
    'address2': profile.address2,
    'address3': profile.address3,
    'postcode': profile.postcode,
    'state': profile.state,
    'contactNumber': profile.contactNumber,
    'logoPath': profile.logoPath,
  };
}
