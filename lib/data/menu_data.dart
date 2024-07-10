final List<String> categories = ["Cakes", "Dishes", "Drinks", "Add On"];
final List<Map<String, dynamic>> menu = [
  {"id": "1", "name": "Egg Tart", "category": "Cakes", "price": 2.40, "image": "assets/cakes/eggTart.png"},
  {"id": "2", "name": "UFO Tart", "category": "Cakes", "price": 2.60, "image": "assets/cakes/ufoTart.png"},
  {"id": "3", "name": "HawFlake Cake", "category": "Cakes", "price": 4.20, "image": "assets/cakes/hawFlakeCake.png"},
  {"id": "4", "name": "Vanila Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/vanilaSwissRoll.png"},
  {"id": "5", "name": "Pandan Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/pandanSwissRoll.png"},
  {"id": "6", "name": "Coffee Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/coffeeSwissRoll.png"},
  {"id": "7", "name": "Chocolate Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/chocolateSwissRoll.png"},
  {"id": "8", "name": "Pandan Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/pandanSwissRollSpecial.png"},
  {"id": "9", "name": "Chicken Floss", "category": "Cakes", "price": 3.00, "image": "assets/cakes/chickenFloss.png"},
  {"id": "10", "name": "Chicken Pie", "category": "Cakes", "price": 2.70, "image": "assets/cakes/chickenPie.png"},
  {"id": "11", "name": "Jam Pie", "category": "Cakes", "price": 1.30, "image": "assets/cakes/jamPie.png"},
  {"id": "12", "name": "Tausa Pie", "category": "Cakes", "price": 1.30, "image": "assets/cakes/tausaPie.png"},
  {"id": "13", "name": "Choc Cream Cake", "category": "Cakes", "price": 3.20, "image": "assets/cakes/chocCreamCake.png"},
  {"id": "14", "name": "Cream Cake", "category": "Cakes", "price": 3.20, "image": "assets/cakes/creamCake.png"},
  {"id": "15", "name": "Steam Cake", "category": "Cakes", "price": 2.00, "image": "assets/cakes/steamCake.png"},
  {"id": "16", "name": "Cream Puff", "category": "Cakes", "price": 2.50, "image": "assets/cakes/creamPuff.png"},
  {"id": "17", "name": "Curry Puff", "category": "Cakes", "price": 2.70, "image": "assets/cakes/curryPuff.png"},
  {"id": "18", "name": "Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/custardCake.png"},
  {"id": "19", "name": "Vanila Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/vanilaCustardCake.png"},
  {"id": "20", "name": "Butter Choc Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/butterChocolateCake.png"},
  {"id": "21", "name": "Honey Comb", "category": "Cakes", "price": 2.40, "image": "assets/cakes/honeyComb.png"},
  {"id": "22", "name": "Cheese Tart", "category": "Cakes", "price": 3.50, "image": "assets/cakes/cheeseTart.png"},
  {"id": "23", "name": "Chocolate Chip", "category": "Cakes", "price": 4.20, "image": "assets/cakes/chocolateChip.png"},
  {"id": "24", "name": "Sponge Cake", "category": "Cakes", "price": 2.00, "image": "assets/cakes/spongeCake.png"},
  {
    "id": "50",
    "name": "Teh",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "O", "Hot": 2.00, "Cold": 2.50},
      {"name": "O Kosong", "Hot": 2.00, "Cold": 2.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "51",
    "name": "Kopi",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/kopi.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "Cham C", "Hot": 2.50, "Cold": 3.50},
      {"name": "O", "Hot": 2.00, "Cold": 2.50},
      {"name": "O Kosong", "Hot": 2.00, "Cold": 2.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "52",
    "name": "Milo",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/milo.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kosong", "Hot": 2.50, "Cold": 3.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "53",
    "name": "Lemon",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/lemon.png",
    "selection": true,
    "drinks": [
      {"name": "Sui", "Hot": 2.50, "Cold": 3.50},
      {"name": "Teh", "Hot": 2.50, "Cold": 3.50},
      {"name": "Sui Asam", "Hot": 2.50, "Cold": 3.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "54",
    "name": "Nescafe",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/nescafe.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "55",
    "name": "Nestum",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "56",
    "name": "Kitcai",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
    "selection": true,
    "drinks": [
      {"name": "Sui", "Hot": 2.50, "Cold": 3.50},
      {"name": "Lemon Asam", "Hot": 2.50, "Cold": 3.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "57",
    "name": "Sang Nai Sui",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
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
    "id": "58",
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
  {"id": "59", "name": "Teh C Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "60", "name": "Kopi C Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {
    "id": "63",
    "name": "Liong Fun",
    "category": "Drinks",
    "price": 3.80,
    "image": "assets/drinks/liongFun.png",
    "selection": true,
    "drinks": [
      {"name": "Liong Fun", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {"id": "64", "name": "Lo Han Kuo", "category": "Drinks", "price": 3.00, "image": "assets/drinks/loHanKuo.png"},
  {"id": "65", "name": "Air Bunga", "category": "Drinks", "price": 3.00, "image": "assets/drinks/example.png"},
  {
    "id": "67",
    "name": "Pandan Soy Milk",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/pandanSoya.png",
    "selection": true,
    "drinks": [
      {"name": "Pandan Soy Milk", "Sugar": 3.50, "No Sugar": 3.00}
    ],
    "temp": [
      {"name": "Sugar"},
      {"name": "No Sugar"}
    ]
  },
  {
    "id": "69",
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
  {"id": "71", "name": "Lai Lo Fa", "category": "Drinks", "price": 4.00, "image": "assets/drinks/laiLoFa.png"},
  {"id": "72", "name": "100 Plus", "category": "Drinks", "price": 2.50, "image": "assets/drinks/100Plus.png"},
  {"id": "73", "name": "Coca Cola", "category": "Drinks", "price": 2.50, "image": "assets/drinks/cocaCola.png"},
  {"id": "74", "name": "EST Cola", "category": "Drinks", "price": 2.50, "image": "assets/drinks/estCola.png"},
  {"id": "75", "name": "F&N Orange", "category": "Drinks", "price": 2.50, "image": "assets/drinks/F&NOrange.png"},
  {"id": "76", "name": "Yeo's Chrys.", "category": "Drinks", "price": 2.50, "image": "assets/drinks/chrysanthemum.png"},
  {"id": "77", "name": "Yeo's Susu Soya", "category": "Drinks", "price": 2.50, "image": "assets/drinks/susuSoya.png"},
  {
    "id": "101",
    "name": "Soup Mee",
    "category": "Dishes",
    "price": 8.00,
    "image": "assets/dishes/soupMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam Goreng", "price": 8.00},
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Seafood", "price": 10.00},
      {"name": "Udang", "price": 12.00},
      {"name": "Ikan", "price": 12.00},
      {"name": "Udang & Ikan", "price": 12.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "102",
    "name": "Kono Mee",
    "category": "Dishes",
    "price": 8.00,
    "image": "assets/dishes/konoMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam Goreng", "price": 8.00},
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Seafood", "price": 10.00},
      {"name": "Udang", "price": 12.00},
      {"name": "Ikan", "price": 12.00},
      {"name": "Udang & Ikan", "price": 12.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "103",
    "name": "Goreng Kering",
    "category": "Dishes",
    "price": 9.00,
    "image": "assets/dishes/gorengKering.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Ayam Goreng", "price": 10.00},
      {"name": "Seafood", "price": 12.00},
      {"name": "Udang", "price": 13.00},
      {"name": "Ikan", "price": 13.00},
      {"name": "Udang & Ikan", "price": 13.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "104",
    "name": "Goreng Basah",
    "category": "Dishes",
    "price": 8.00,
    "image": "assets/dishes/gorengBasah.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam", "price": 8.00},
      {"name": "Ayam Goreng", "price": 9.00},
      {"name": "Seafood", "price": 11.00},
      {"name": "Udang", "price": 13.00},
      {"name": "Ikan", "price": 13.00},
      {"name": "Udang & Ikan", "price": 13.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ]
  },
  // {
  //   "id": "104",
  //   "name": "Goreng Basah",
  //   "category": "Dishes",
  //   "price": 8.00,
  //   "image": "assets/dishes/gorengBasah.png",
  //   "selection": true,
  //   "choices": [
  //     {"name": "Campur", "price": 8.00},
  //     {"name": "Ayam", "price": 8.00},
  //     {"name": "Ayam Goreng", "price": 9.00},
  //     {"name": "Seafood", "price": 11.00},
  //     {"name": "Udang", "price": 13.00},
  //     {"name": "Ikan", "price": 13.00},
  //     {"name": "Udang & Ikan", "price": 13.00},
  //   ],
  //   "types": [
  //     {"name": "Kuey Teow", "price": 0.00},
  //     {"name": "Mihun Halus", "price": 0.00},
  //     {"name": "Mihun Kasar", "price": 0.00},
  //     {"name": "Mee Kuning", "price": 0.00},
  //     {"name": "Mee Telur", "price": 0.00},
  //     {"name": "Yee Mee", "price": 0.00},
  //   ],
  //   "meat portion": [
  //     {"name": "Normal Meat", "price": 0.00},
  //     {"name": "Extra Meat", "price": 2.00}
  //   ],
  //   "mee portion": [
  //     {"name": "Normal", "price": 0.00},
  //     {"name": "Less", "price": 0.00},
  //     {"name": "Extra Mee", "price": 2.00},
  //     {"name": "Extra Mee Telur", "price": 2.50},
  //   ],
  //   "add on": [
  //     {"name": "Prawn Ball", "price": 1.50},
  //     {"name": "Soto", "price": 1.50},
  //     {"name": "Laksa", "price": 2.00},
  //     {"name": "Curry Laksa", "price": 2.00},
  //     // {"name": "Goreng Set", "price": 2.50},
  //   ]
  // },
  {
    "id": "105",
    "name": "Laksa",
    "category": "Dishes",
    "price": 10.00,
    "image": "assets/dishes/laksa.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam Goreng", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 13.00},
      {"name": "Udang", "price": 14.00},
      {"name": "Ikan", "price": 14.00},
      {"name": "Udang & Ikan", "price": 14.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "106",
    "name": "Lo Mee",
    "category": "Dishes",
    "price": 10.00,
    "image": "assets/dishes/loMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00},
      {"name": "Udang", "price": 14.00},
      {"name": "Ikan", "price": 14.00},
      {"name": "Udang & Ikan", "price": 14.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "107",
    "name": "Watan Hor",
    "category": "Dishes",
    "price": 10.00,
    "image": "assets/dishes/watanHor.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00},
      {"name": "Udang", "price": 14.00},
      {"name": "Ikan", "price": 14.00},
      {"name": "Udang & Ikan", "price": 14.00},
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Less Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      
    ],
  },
  {
    "id": "108",
    "name": "Nasi Ayam",
    "category": "Dishes",
    "price": 7.00,
    "image": "assets/dishes/chickenRice.png",
    "selection": true,
    "choices": [
      {"name": "Goreng Ayam", "price": 7.00},
      {"name": "Ayam Kicap", "price": 7.00},
    ],
    "types": [
      {"name": "Nasi", "price": 0.00},
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun", "price": 0.00},
      {"name": "Mee", "price": 0.00},
    ],
  },
  {
    "id": "109",
    "name": "Eco Noodles",
    "category": "Dishes",
    "price": 2.00,
    "image": "assets/dishes/ecoNoodles.png",
    "selection": true,
    "choices": [
      {"name": "Normal", "price": 2.00},
      {"name": "Extra Mee", "price": 2.50},
    ],
    "types": [
      {"name": "Mihun", "price": 0.00},
      {"name": "Mee", "price": 0.00},
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Nasi", "price": 0.00},
      {"name": "Kosong", "price": 0.00},
    ],
    "add on": [
      {"name": "Egg", "price": 1.50},
      {"name": "Fish Ball", "price": 1.50},
      {"name": "Fish Cake", "price": 1.50},
      {"name": "Ayam Goreng", "price": 2.00},
      {"name": "Sausage", "price": 1.50},
      {"name": "Eggplant", "price": 1.50},
      {"name": "Wonton", "price": 1.50},
      {"name": "Fried Chicken", "price": 6.00},
      {"name": "Ayam Kicap", "price": 6.00},
      {"name": "Beancurd Skin", "price": 1.50},
      {"name": "Curry Tofo", "price": 1.50},
    ]
  },
  {
    "id": "110",
    "name": "Sui Kau",
    "category": "Dishes",
    "price": 9.00,
    "image": "assets/dishes/suiKau.png",
    "selection": true,
    "choices": [
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Campur", "price": 10.00},
      {"name": "Udang", "price": 12.00},
      {"name": "Ikan", "price": 12.00},
      {"name": "Udang & Ikan", "price": 12.00},
    ],
    "types": [
      {"name": "Soup", "price": 0.00},
      {"name": "Kono", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "add on": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
    ],
  },
  {"id": "150", "name": "Fried Egg", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEgg.png"},
  {"id": "151", "name": "Ayam Goreng", "category": "Add On", "price": 2.00, "image": "assets/addOn/ayamGoreng.png"},
  {"id": "152", "name": "Sausage", "category": "Add On", "price": 1.50, "image": "assets/addOn/sausage.png"},
  {"id": "153", "name": "Fried Eggplant", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEggplant.png"},
  {"id": "154", "name": "Fried Wonton", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedWonton.png"},
  {"id": "155", "name": "Fried Chicken", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiGorengAyam.png"},
  {"id": "156", "name": "Ayam Kicap", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiAyam.png"},
  {"id": "157", "name": "Curry Tofu", "category": "Add On", "price": 1.50, "image": "assets/addOn/curryTofu.png"},
  {"id": "158", "name": "Fish Ball", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishBall.png"},
  {"id": "159", "name": "Fish Cake", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishCake.png"},
  {"id": "160", "name": "Dessert", "category": "Add On", "price": 4.00, "image": "assets/addOn/dessert.png"},
  {"id": "161", "name": "Beancurd Skin", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedBeancurdSkin.png"},
  {"id": "162", "name": "Rice", "category": "Add On", "price": 2.00, "image": "assets/addOn/rice.png"},
];
