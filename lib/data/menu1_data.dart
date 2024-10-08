final List<String> categories = ["Soup", "Dishes", "Drinks", "Add On"];
final List<Map<String, dynamic>> menu1 = [
  {
    "id": "1",
    "name": "Curry Laksa",
    "category": "Dishes",
    "price": 10.00,
    "image": "assets/dishes/watanHor.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Ayam GOreng", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00},
      {"name": "Udang", "price": 14.00},
      {"name": "Ikan", "price": 14.00},
      {"name": "Udang & Ikan", "price": 14.00},
    ],
    "noodlesTypes": [
      {"name": "Mihun", "price": 0.00},
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
      {"name": "Spring Mee", "price": 0.00},
      {"name": "Knife Cut Noodles", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 1.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      {"name": "Udang", "price": 0.00},
      {"name": "Ikan", "price": 0.00},
      {"name": "Sotong", "price": 0.00},
    ],
  },
  {
    "id": "70",
    "name": "Kopi",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.00, "Cold": 3.00},
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Sang Suk Nai", "Hot": 2.50, "Cold": 3.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "71",
    "name": "Teh",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.00, "Cold": 3.00},
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Sang Suk Nai", "Hot": 2.50, "Cold": 3.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "72",
    "name": "Nescafe",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.50, "Cold": 3.50},
      {"name": "C", "Hot": 3.00, "Cold": 4.00},
      {"name": "Nai", "Hot": 3.00, "Cold": 4.00},
      {"name": "Sang Suk Nai", "Hot": 3.00, "Cold": 4.00},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "73",
    "name": "Milo",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.50, "Cold": 3.50},
      {"name": "C", "Hot": 3.00, "Cold": 4.00},
      {"name": "Nai", "Hot": 3.00, "Cold": 4.00},
      {"name": "Sang Suk Nai", "Hot": 3.00, "Cold": 4.00},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "74",
    "name": "Nestum",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.50, "Cold": 3.50},
      {"name": "C", "Hot": 3.00, "Cold": 4.00},
      {"name": "Nai", "Hot": 3.00, "Cold": 4.00},
      {"name": "Sang Suk Nai", "Hot": 3.00, "Cold": 4.00},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "75",
    "name": "Lemon",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "Sui", "Hot": 2.50, "Cold": 3.50},
      {"name": "Teh", "Hot": 3.00, "Cold": 4.00},
      {"name": "Asam Boi", "Hot": 3.00, "Cold": 4.00},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "76",
    "name": "Sang Suk Nai",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/sangSukLai.png",
    "selection": true,
    "drinks": [
      {"name": "Sang Suk Nai", "Hot": 2.50, "Cold": 3.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "77",
    "name": "Sang Nai Sui",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/sangSukLai.png",
    "selection": true,
    "drinks": [
      {"name": "Sang Nai Sui", "Hot": 2.50, "Cold": 3.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "78",
    "name": "Kit Zai Sui",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/sangSukLai.png",
    "selection": true,
    "drinks": [
      {"name": "Kit Zai Sui", "Hot": 3.00, "Cold": 4.00}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "79",
    "name": "Hoko",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/sangSukLai.png",
    "selection": true,
    "drinks": [
      {"name": "Hoko", "Hot": 3.50, "Cold": 4.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {"id": "80", "name": "Oren", "category": "Drinks", "price": 4.00, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "81", "name": "Oren Lemon", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "82", "name": "Cincau Susu", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "83", "name": "Air Sirap", "category": "Drinks", "price": 4.00, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "84", "name": "Teh C Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "85", "name": "Kopi Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "86", "name": "Wheatgrass", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {
    "id": "92",
    "name": "Air Bandung",
    "category": "Drinks",
    "price": 0.50,
    "image": "assets/drinks/chineseTeh.png",
    "selection": true,
    "drinks": [
      {"name": "Air Bandung", "Cold": 4.50},
      {"name": "Cincau",  "Cold": 5.00},
    ],
    "temp": [
      {"name": "Cold"}
    ]
  },
  {"id": "87", "name": "Air Bandung", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "88", "name": "Air Bandung Cincau", "category": "Drinks", "price": 5.00, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "89", "name": "Minimum Tin", "category": "Drinks", "price": 3.00, "image": "assets/drinks/tehCSpecial.png"},
 {
    "id": "90",
    "name": "Chinese Teh",
    "category": "Drinks",
    "price": 0.50,
    "image": "assets/drinks/chineseTeh.png",
    "selection": true,
    "drinks": [
      {"name": "Chinese Teh", "Hot": 0.50, "Cold": 0.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "91",
    "name": "Sky Juice (Water)",
    "category": "Drinks",
    "price": 0.50,
    "image": "assets/drinks/chineseTeh.png",
    "selection": true,
    "drinks": [
      {"name": "Sky Juice (Water)", "Hot": 0.50, "Cold": 0.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
];