final List<String> categories = ["Cakes", "Dishes", "Drinks", "Add On"];
final List<Map<String, dynamic>> menu = [
  {"id": "1", "name": "Egg Tart", "category": "Cakes", "price": 2.40, "image": "assets/cakes/eggTart.png"},
  {"id": "2", "name": "UFO Tart", "category": "Cakes", "price": 2.60, "image": "assets/cakes/ufoTart.png"},
  {"id": "3", "name": "Cheese Tart", "category": "Cakes", "price": 2.50, "image": "assets/cakes/cheeseTart.png"},
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
  {"id": "16", "name": "Steam Cake (BIG)", "category": "Cakes", "price": 24.00, "image": "assets/cakes/steamCakeBig.png"},
  {"id": "17", "name": "Cream Puff", "category": "Cakes", "price": 2.50, "image": "assets/cakes/creamPuff.png"},
  {"id": "18", "name": "Curry Puff", "category": "Cakes", "price": 2.70, "image": "assets/cakes/curryPuff.png"},
  {"id": "19", "name": "Curry Puff + Egg", "category": "Cakes", "price": 3.00, "image": "assets/cakes/curryPuff.png"},
  {"id": "20", "name": "Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/custardCake.png"},
  {"id": "21", "name": "Vanila Custard Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/vanilaCustardCake.png"},
  {"id": "22", "name": "Butter Choc Cake", "category": "Cakes", "price": 3.00, "image": "assets/cakes/butterChocolateCake.png"},
  {"id": "23", "name": "Honey Comb", "category": "Cakes", "price": 2.40, "image": "assets/cakes/honeyComb.png"},
  {"id": "24", "name": "Sponge Cake", "category": "Cakes", "price": 2.00, "image": "assets/cakes/spongeCake.png"},
  {"id": "25", "name": "Sponge Cake (200g)", "category": "Cakes", "price": 9.00, "image": "assets/cakes/spongeCake200g.png"},
  {"id": "26", "name": "Chocolate Muffin", "category": "Cakes", "price": 4.00, "image": "assets/cakes/chocMuffin.png"},
  {"id": "27", "name": "Coffee Butter", "category": "Cakes", "price": 2.50, "image": "assets/cakes/coffeeButter.png"},
  {"id": "28", "name": "Butter Cake", "category": "Cakes", "price": 2.50, "image": "assets/cakes/butterCake.png"},
  {"id": "29", "name": "Banana Cake", "category": "Cakes", "price": 2.50, "image": "assets/cakes/bananaCake.png"},
  {"id": "30", "name": "HawFlake Cake", "category": "Cakes", "price": 4.20, "image": "assets/cakes/hawFlakeCake.png"},
  {"id": "31", "name": "Chocolate Chip", "category": "Cakes", "price": 4.20, "image": "assets/cakes/chocolateChip.png"},
  {"id": "32", "name": "Raising Cake", "category": "Cakes", "price": 4.20, "image": "assets/cakes/raisingCake.png"},
  {"id": "33", "name": "Sausage Bun", "category": "Cakes", "price": 3.00, "image": "assets/cakes/sausageBun.png"},
  {"id": "34", "name": "Ham Cheese Bun", "category": "Cakes", "price": 3.50, "image": "assets/cakes/smkHamCheeseChicRoll.png"},
  {
    "id": "70",
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
    "id": "71",
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
    "id": "72",
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
      {"name": "Nai", "Hot": 2.50, "Cold": 3.50},
      {"name": "C Kosong", "Hot": 2.50, "Cold": 3.50},
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
  {"id": "79", "name": "Teh C Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {"id": "80", "name": "Kopi C Special", "category": "Drinks", "price": 4.50, "image": "assets/drinks/tehCSpecial.png"},
  {
    "id": "81",
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
  {"id": "82", "name": "Lo Han Kuo", "category": "Drinks", "price": 3.00, "image": "assets/drinks/loHanKuo.png"},
  {"id": "83", "name": "Air Bunga", "category": "Drinks", "price": 3.00, "image": "assets/drinks/example.png"},
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
  {"id": "86", "name": "Lai Lo Fa", "category": "Drinks", "price": 4.00, "image": "assets/drinks/laiLoFa.png"},
  {
    "id": "87",
    "name": "Soft Drink",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/softDrinks.png",
    "selection": true,
    "drinks": [
      {"name": "Coca Cola","Cold": 2.50},
      {"name": "100 Plus","Cold": 2.50},
      {"name": "F&N Orange","Cold": 2.50},
      {"name": "F&N Strawberry","Cold": 2.50},
      {"name": "Yeo's Chrys.","Cold": 2.50},
      {"name": "Yeo's Susu Soya","Cold": 2.50},
      {"name": "EST Cola","Cold": 2.50},
      {"name": "Mountain Dew","Cold": 2.50},
      {"name": "Mountain Dew Anggur","Cold": 2.50},
      {"name": "A&W","Cold": 2.50},
      {"name": "7UP","Cold": 2.50},
      {"name": "KickaPoo","Cold": 2.50},
    ],
    "temp": [
      {"name": "Cold"}
    ]
  },
  {"id": "88", "name": "Ubi Manis", "category": "Drinks", "price": 4.00, "image": "assets/drinks/ubiManisTongShui.png"},

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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
    ],
    "mee portion": [
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00},
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
    "id": "128",
    "name": "Nasi Ayam",
    "category": "Dishes",
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
    "category": "Dishes",
    "price": 2.00,
    "image": "assets/dishes/ecoNoodles.png",
    "selection": true,
    "choices": [
      {"name": "Normal", "price": 2.00},
      {"name": "Extra Mee", "price": 2.50},
      {"name": "Kosong", "price": 0.00},
    ],
    "noodlesTypes": [
      {"name": "Mihun", "price": 0.00},
      {"name": "Mee", "price": 0.00},
      {"name": "Kuey Teow", "price": 0.00},
    ],
    "add on": [
      {"name": "Egg", "price": 1.50},
      {"name": "Fish Ball", "price": 1.50},
      {"name": "Fish Cake", "price": 1.50},
      {"name": "Ayam Goreng", "price": 2.00},
      {"name": "Sausage", "price": 1.50},
      {"name": "Eggplant", "price": 1.50},
      {"name": "Fried Wonton", "price": 1.50},
      {"name": "Fried Chicken", "price": 6.00},
      {"name": "Ayam Kicap", "price": 6.00},
      {"name": "Beancurd Skin", "price": 1.50},
      {"name": "Curry Tofo", "price": 1.50},
      {"name": "Peria", "price": 1.50},
    ]
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
      {"name": "Extra Meat", "price": 2.00},
      {"name": "Less Meat", "price": 0.00}
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
  {"id": "170", "name": "Fried Egg", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEgg.png"},
  {"id": "171", "name": "Ayam Goreng", "category": "Add On", "price": 2.00, "image": "assets/addOn/ayamGoreng2.png"},
  {"id": "172", "name": "Sausage", "category": "Add On", "price": 1.50, "image": "assets/addOn/sausage.png"},
  {"id": "173", "name": "Fried Eggplant", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedEggplant.png"},
  {"id": "174", "name": "Fried Wonton", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedWonton.png"},
  {"id": "175", "name": "Fried Chicken", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiGorengAyam.png"},
  {"id": "176", "name": "Ayam Kicap", "category": "Add On", "price": 6.00, "image": "assets/dishes/nasiAyam.png"},
  {"id": "177", "name": "Curry Tofu", "category": "Add On", "price": 1.50, "image": "assets/addOn/curryTofu1.png"},
  {"id": "178", "name": "Fish Ball", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishBall.png"},
  {"id": "179", "name": "Fish Cake", "category": "Add On", "price": 1.50, "image": "assets/addOn/fishCake.png"},
  {"id": "180", "name": "Beancurd Skin", "category": "Add On", "price": 1.50, "image": "assets/addOn/friedBeancurdSkin1.png"},
  {"id": "181", "name": "Peria", "category": "Add On", "price": 2.00, "image": "assets/addOn/peria.png"},
  {"id": "182", "name": "Rice", "category": "Add On", "price": 2.00, "image": "assets/addOn/rice.png"},
];
