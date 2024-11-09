import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/client_profile.dart';

// Provider to open the Hive box for client profiles
final clientProfileBoxProvider = FutureProvider<Box<ClientProfile>>((ref) async {
  var box = await Hive.openBox<ClientProfile>('clientProfiles');
  
  // Check if the box is empty and add or update the hard-coded profile if necessary
  await addOrUpdateHardCodedClientProfile(box);
  
  // Future cloud sync logic can go here (e.g., download from cloud)
  log('Client profile loaded and synced (if needed).');

  return box;
});

// Modified function to add or update the client profile
Future<void> addOrUpdateHardCodedClientProfile(Box<ClientProfile> box) async {
  // Define the hard-coded profile data
  var newProfile = ClientProfile(
    name: "TryMee IJM",
    businessRegistrationNumber: "123456789",
    tinNumber: "TIN987654321",
    address1: "Lot 14, Ground Floor Utama Zone 3 Commercial, Jalan Dataran BU3",
    address2: "90000 Sandakan, Sabah, Malaysia",
    postcode: "90000",
    state: "Sabah",
    contactNumber: "+6011-5873 0128",
    // logoPath: "/path/to/logo.png",
  );

  // Find if the profile with matching business registration number exists
  var profileIndex = box.values.toList().indexWhere(
      (profile) => profile.businessRegistrationNumber == newProfile.businessRegistrationNumber);

  if (profileIndex != -1) {
    // Update the existing entry
    await box.putAt(profileIndex, newProfile);
    log('Profile updated in Hive box.');
  } else {
    // Add the new profile if no matching profile is found
    await box.add(newProfile);
    log('Profile added to Hive box.');
  }
}


// Restaurant Sing Ming Hing
  // Lot 16, Block B, Utara Place 1, Jalan Utara,
  // IJM Batu 6, Sandakan, Malaysia
  // Contact: +6016 822 6188

  // TryMee IJM
  // Lot 14, Ground Floor Utama Zone 3 Commercial,
  // Jalan Dataran BU3, Sandakan, Malaysia
  // Contact: +6011-5873 0128

// Hard-coded profile function
// Future<void> addHardCodedClientProfile(Box<ClientProfile> box) async {
//   var profile = ClientProfile(
//     name: "Restaurant Sing Ming Hing",
//     businessRegistrationNumber: "123456789",
//     tinNumber: "TIN987654321",
//     address1: "Lot 16, Block B, Utara Place 1, Jalan Utara",
//     address2: "IJM Batu 6, Sandakan, Malaysia",
//     postcode: "90000",
//     state: "Sabah",
//     contactNumber: "+6016-822 6188",
//     // logoPath: "/path/to/logo.png",
//   );

//   await box.add(profile);
// }