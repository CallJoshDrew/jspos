final List<String> categories = ["Cakes", "Dishes", "Drinks", "Add On"];
final List<Map<String, dynamic>> menu = [
  {"id": "1", "name": "Egg Tart", "category": "Cakes", "price": 2.40, "image": "assets/cakes/eggTart.png", "selection": false},
  {"id": "2", "name": "UFO Tart", "category": "Cakes", "price": 2.60, "image": "assets/cakes/ufoTart.png", "selection": false},
  {"id": "3", "name": "Cheese Tart", "category": "Cakes", "price": 2.50, "image": "assets/cakes/cheeseTart.png", "selection": false},
  {"id": "4", "name": "Vanila Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/vanilaSwissRoll.png", "selection": false},
  {"id": "5", "name": "Pandan Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/pandanSwissRoll.png", "selection": false},
  {"id": "6", "name": "Coffee Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/coffeeSwissRoll.png", "selection": false},
  {"id": "7", "name": "Chocolate Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/chocolateSwissRoll.png", "selection": false},
  {"id": "8", "name": "Pandan Swiss Roll", "category": "Cakes", "price": 2.40, "image": "assets/cakes/pandanSwissRollSpecial.png", "selection": false},
  {"id": "9", "name": "Chicken Floss", "category": "Cakes", "price": 3.00, "image": "assets/cakes/chickenFloss.png", "selection": false},
  {"id": "10", "name": "Chicken Pie", "category": "Cakes", "price": 2.70, "image": "assets/cakes/chickenPie.png", "selection": false},
  {"id": "11", "name": "Jam Pie", "category": "Cakes", "price": 1.30, "image": "assets/cakes/jamPie.png", "selection": false},
  {"id": "12", "name": "Tausa Pie", "category": "Cakes", "price": 1.30, "image": "assets/cakes/tausaPie.png", "selection": false},
  {"id": "13", "name": "Choc Cream Cake", "category": "Cakes", "price": 3.20, "image": "assets/cakes/chocCreamCake.png", "selection": false},
  {"id": "14", "name": "Cream Cake", "category": "Cakes", "price": 3.20, "image": "assets/cakes/creamCake.png", "selection": false},
  {"id": "15", "name": "Steam Cake", "category": "Cakes", "price": 2.00, "image": "assets/cakes/steamCake.png", "selection": false},
  {"id": "16", "name": "Steam Cake (BIG)", "category": "Cakes", "price": 24.00, "image": "assets/cakes/steamCakeBig.png", "selection": false},
  {"id": "17", "name": "Cream Puff", "category": "Cakes", "price": 2.50, "image": "assets/cakes/creamPuff.png", "selection": false},
  {"id": "18", "name": "Curry Puff", "category": "Cakes", "price": 2.70, "image": "assets/cakes/curryPuff.png", "selection": false},
  {"id": "19", "name": "Curry Puff + Egg", "category": "Cakes", "price": 3.00, "image": "assets/cakes/curryPuff.png", "selection": false},
  {"id": "20", "name": "Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/custardCake.png", "selection": false},
  {"id": "21", "name": "Vanila Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/vanilaCustardCake.png", "selection": false},
  {"id": "22", "name": "Butter Choc Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/butterChocolateCake.png", "selection": false},
  {"id": "23", "name": "Honey Comb", "category": "Cakes", "price": 2.40, "image": "assets/cakes/honeyComb.png", "selection": false},
  {"id": "24", "name": "Sponge Cake", "category": "Cakes", "price": 2.00, "image": "assets/cakes/spongeCake.png", "selection": false},
  {"id": "25", "name": "Sponge Cake (200g)", "category": "Cakes", "price": 9.00, "image": "assets/cakes/spongeCake200g.png", "selection": false},
  {"id": "26", "name": "Chocolate Muffin", "category": "Cakes", "price": 4.00, "image": "assets/cakes/chocMuffin.png", "selection": false},
  {"id": "27", "name": "Coffee Butter", "category": "Cakes", "price": 2.50, "image": "assets/cakes/coffeeButter.png", "selection": false},
  {"id": "28", "name": "Butter Cake", "category": "Cakes", "price": 2.50, "image": "assets/cakes/butterCake.png", "selection": false},
  {"id": "29", "name": "Banana Cake", "category": "Cakes", "price": 2.50, "image": "assets/cakes/bananaCake.png", "selection": false},
  {"id": "30", "name": "HawFlake Cake", "category": "Cakes", "price": 4.20, "image": "assets/cakes/hawFlakeCake.png", "selection": false},
  {"id": "31", "name": "Chocolate Chip", "category": "Cakes", "price": 4.20, "image": "assets/cakes/chocolateChip.png", "selection": false},
  {"id": "32", "name": "Raising Cake", "category": "Cakes", "price": 4.20, "image": "assets/cakes/raisingCake.png", "selection": false},
  {"id": "33", "name": "Sausage Bun", "category": "Cakes", "price": 3.00, "image": "assets/cakes/sausageBun.png", "selection": false},
  {"id": "34", "name": "Ham Cheese Bun", "category": "Cakes", "price": 3.50, "image": "assets/cakes/smkHamCheeseChicRoll.png", "selection": false},
  {
    "id": "70",
    "name": "Teh",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.00, "Cold": 2.50},
      {"name": "O Kosong", "Hot": 2.00, "Cold": 2.50},
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "Tarik", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Special", "Cold": 4.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "71",
    "name": "Kopi",
    "category": "Drinks",
    "price": 2.00,
    "image": "assets/drinks/kopi.png",
    "selection": true,
    "drinks": [
      {"name": "O", "Hot": 2.00, "Cold": 2.50},
      {"name": "O Kosong", "Hot": 2.00, "Cold": 2.50},
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "Kahwin", "Hot": 2.50, "Cold": 3.50},
      {"name": "Cham C", "Hot": 2.50, "Cold": 3.50},
      {"name": "Tarik", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Special", "Cold": 4.50},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"},
    ]
  },
  {
    "id": "72",
    "name": "Milo",
    "category": "Drinks",
    "price": 2.80,
    "image": "assets/drinks/milo.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.80, "Cold": 3.80},
      {"name": "Kosong", "Hot": 2.80, "Cold": 3.80},
      {"name": "C Kosong", "Hot": 2.80, "Cold": 3.80},
      {"name": "Nai", "Hot": 2.80, "Cold": 3.80},
      {"name": "Kahwin", "Hot": 2.80, "Cold": 3.80},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "73",
    "name": "Lemon",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/lemon.png",
    "selection": true,
    "drinks": [
      {"name": "Sui", "Hot": 2.50, "Cold": 3.50},
      {"name": "Teh", "Hot": 2.50, "Cold": 3.50},
      {"name": "Sui Asam", "Hot": 2.80, "Cold": 3.80}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "74",
    "name": "Nescafe",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/nescafe.png",
    "selection": true,
    "drinks": [
      {"name": "C", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.80, "Cold": 3.80},
      {"name": "Kahwin", "Hot": 2.80, "Cold": 3.80},
      {"name": "Tarik", "Hot": 2.80, "Cold": 3.80},
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {
    "id": "75",
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
    "id": "76",
    "name": "Kitcai",
    "category": "Drinks",
    "price": 2.80,
    "image": "assets/drinks/example.png",
    "selection": true,
    "drinks": [
      {"name": "Sui", "Hot": 2.80, "Cold": 3.80},
      {"name": "Lemon Asam", "Hot": 3.00, "Cold": 4.00}
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
    "id": "78",
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
    "id": "81",
    "name": "Liong Fun",
    "category": "Drinks",
    "price": 3.80,
    "image": "assets/drinks/liongFun.png",
    "selection": true,
    "drinks": [
      {"name": "Liong Fun", "Hot": 2.50, "Cold": 3.50},
      {"name": "Nai", "Hot": 2.80, "Cold": 3.80}
    ],
    "temp": [
      {"name": "Hot"},
      {"name": "Cold"}
    ]
  },
  {"id": "82", "name": "Lo Han Kuo", "category": "Drinks", "price": 3.00, "image": "assets/drinks/loHanKuo.png", "selection": false},
  {"id": "83", "name": "Air Bunga", "category": "Drinks", "price": 3.00, "image": "assets/drinks/example.png", "selection": false},
  {
    "id": "84",
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
    "id": "85",
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
  {"id": "86", "name": "Lai Lo Fa", "category": "Drinks", "price": 4.00, "image": "assets/drinks/laiLoFa.png", "selection": false},
  {
    "id": "87",
    "name": "Soft Drink",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/softDrinks.png",
    "selection": true,
    "drinks": [
      {"name": "Coca", "Cold": 2.50},
      {"name": "100Plus", "Cold": 2.50},
      {"name": "Orange", "Cold": 2.50},
      {"name": "Strawberry", "Cold": 2.50},
      {"name": "Chrys", "Cold": 2.50},
      {"name": "Susu Soya", "Cold": 2.50},
      {"name": "EST Cola", "Cold": 2.50},
      {"name": "M.DEW", "Cold": 2.50},
      {"name": "M.Dew Anggur", "Cold": 2.50},
      {"name": "A&W", "Cold": 2.50},
      {"name": "7UP", "Cold": 2.50},
      {"name": "KickaPoo", "Cold": 2.50},
    ],
    "temp": [
      {"name": "Cold"}
    ]
  },
  {"id": "88", "name": "Ubi Manis", "category": "Drinks", "price": 4.00, "image": "assets/drinks/ubiManisTongShui.png", "selection": false},
  {"id": "89", "name": "Fu Zuk", "category": "Drinks", "price": 4.00, "image": "assets/drinks/fuZuk.png", "selection": false},
  {
    "id": "121",
    "name": "Soup Mee",
    "category": "Dishes",
    "price": 8.00,
    "image": "assets/dishes/soupMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam Goreng", "price": 9.00},
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Seafood", "price": 10.00},
      {"name": "Udang", "price": 12.00},
      {"name": "Ikan", "price": 12.00},
      {"name": "Udang & Ikan", "price": 12.00},
    ],
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "122",
    "name": "Kono Mee",
    "category": "Dishes",
    "price": 8.00,
    "image": "assets/dishes/konoMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam Goreng", "price": 9.00},
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Seafood", "price": 10.00},
      {"name": "Udang", "price": 12.00},
      {"name": "Ikan", "price": 12.00},
      {"name": "Udang & Ikan", "price": 12.00},
    ],
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "123",
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
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "124",
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
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      {"name": "Udang", "price": 0.00},
      {"name": "Ikan", "price": 0.00},
      {"name": "Sotong", "price": 0.00},
    ]
  },
  {
    "id": "125",
    "name": "Laksa",
    "category": "Dishes",
    "price": 10.00,
    "image": "assets/dishes/laksa.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam Goreng", "price": 11.00},
      {"name": "Sui Kau", "price": 11.00},
      {"name": "Seafood", "price": 13.00},
      {"name": "Udang", "price": 14.00},
      {"name": "Ikan", "price": 14.00},
      {"name": "Udang & Ikan", "price": 14.00},
    ],
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "126",
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
    "noodlesTypes": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "127",
    "name": "Watan Hor",
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
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
      {"name": "Less Mee", "price": 0.00},
    ],
    "sides": [
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
    "id": "128",
    "name": "Nasi Ayam",
    "category": "Add On",
    "price": 7.00,
    "image": "assets/dishes/chickenRice.png",
    "selection": true,
    "choices": [
      {"name": "Goreng Ayam", "price": 7.00},
      {"name": "Ayam Kicap", "price": 7.00},
    ],
    "noodlesTypes": [
      {"name": "Nasi", "price": 0.00},
    ],
  },
  {
    "id": "129",
    "name": "Eco Noodles",
    "category": "Add On",
    "price": 2.00,
    "image": "assets/dishes/ecoNoodles.png",
    "selection": true,
    "choices": [
      {"name": "Normal", "price": 2.00},
      {"name": "Extra Mee", "price": 2.50},
      // {"name": "Kosong", "price": 0.00},
    ],
    "noodlesTypes": [
      {"name": "Mihun", "price": 0.00},
      {"name": "Mee", "price": 0.00},
      {"name": "Kuey Teow", "price": 0.00},
    ],
    // "sides": [
    //   {"name": "Egg", "price": 1.50},
    //   {"name": "Fish Ball", "price": 1.50},
    //   {"name": "Fish Cake", "price": 1.50},
    //   {"name": "Ayam Goreng", "price": 2.00},
    //   {"name": "Sausage", "price": 1.50},
    //   {"name": "Eggplant", "price": 1.50},
    //   {"name": "Fried Wonton", "price": 1.50},
    //   {"name": "Fried Chicken", "price": 6.00},
    //   {"name": "Ayam Kicap", "price": 6.00},
    //   {"name": "Beancurd Skin", "price": 1.50},
    //   {"name": "Curry Tofo", "price": 1.50},
    //   {"name": "Peria", "price": 1.50},
    // ]
  },
  {
    "id": "130",
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
    "noodlesTypes": [
      {"name": "Soup", "price": 0.00},
      {"name": "Kono", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal Meat", "price": 0.00},
      {"name": "Extra Meat", "price": 3.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "sides": [
      {"name": "Yu Fu", "price": 0.00},
      {"name": "Fish Ball", "price": 0.00},
      {"name": "Yu Wat", "price": 0.00},
      {"name": "Fish Cake", "price": 0.00},
      {"name": "Udang", "price": 0.00},
      {"name": "Ikan", "price": 0.00},
      {"name": "Sotong", "price": 0.00},
    ],
  },
  {"id": "170", "name": "Fried Egg", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEgg.png", "selection": false},
  {"id": "171", "name": "Ayam Goreng", "category": "Add On", "price": 2.00, "image": "assets/addOn/ayamGoreng2.png", "selection": false},
  {"id": "172", "name": "Sausage", "category": "Add On", "price": 1.50, "image": "assets/addOn/sausage.png", "selection": false},
  {"id": "173", "name": "Fried Eggplant", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEggplant.png", "selection": false},
  {"id": "174", "name": "Fried Wonton", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedWonton.png", "selection": false},
  {"id": "175", "name": "Fried Chicken", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiGorengAyam.png", "selection": false},
  {"id": "176", "name": "Ayam Kicap", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiAyam.png", "selection": false},
  {"id": "177", "name": "Curry Tofu", "category": "Add On", "price": 1.50, "image": "assets/addOn/curryTofu1.png", "selection": false},
  {"id": "178", "name": "Fish Ball", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishBall.png", "selection": false},
  {"id": "179", "name": "Fish Cake", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishCake.png", "selection": false},
  {"id": "180", "name": "Beancurd Skin", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedBeancurdSkin1.png", "selection": false},
  {"id": "181", "name": "Peria", "category": "Add On", "price": 1.50, "image": "assets/addOn/peria.png", "selection": false},
  {"id": "182", "name": "Rice", "category": "Add On", "price": 2.00, "image": "assets/addOn/rice.png", "selection": false},
  {
    "id": "183",
    "name": "Roti Panggang",
    "category": "Add On",
    "price": 2.50,
    "image": "assets/addOn/rotiBakar.png",
    "selection": true,
    "choices": [
      {"name": "Kahwin", "price": 2.50},
      {"name": "Bakar", "price": 2.50},
    ],
  },
];
