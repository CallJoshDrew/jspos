import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:jspos/models/client_profile.dart';

// Provider to open the Hive box for client profiles
final clientProfileBoxProvider = FutureProvider<Box<ClientProfile>>((ref) async {
  var box = await Hive.openBox<ClientProfile>('clientProfiles');
  
  // Check if the box is empty and add the hard-coded profile if necessary
  if (box.isEmpty) {
    await addHardCodedClientProfile(box);
  }
  
  // Future cloud sync logic can go here (e.g., download from cloud)
  log('Client profile loaded and synced (if needed).');

  return box;
});
// Restaurant Sing Ming Hing
  // Lot 16, Block B, Utara Place 1, Jalan Utara,
  // IJM Batu 6, Sandakan, Malaysia
  // Contact: +6016 822 6188

  // TryMee IJM
  // Lot 14, Ground Floor Utama Zone 3 Commercial,
  // Jalan Dataran BU3, Sandakan, Malaysia
  // Contact: +6011-5873 0128

// Hard-coded profile function
Future<void> addHardCodedClientProfile(Box<ClientProfile> box) async {
  var profile = ClientProfile(
    name: "TryMee IJM",
    businessRegistrationNumber: "123456789",
    tinNumber: "TIN987654321",
    address1: "Lot 14, Ground Floor Utama Zone 3 Commercial",
    address2: "Jalan Dataran BU3, Sandakan, Malaysia",
    postcode: "90000",
    state: "Sabah",
    contactNumber: "+6011-5873 0128",
    // logoPath: "/path/to/logo.png",
  );

  await box.add(profile);
}
