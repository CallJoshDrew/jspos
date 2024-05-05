final List<String> categories = ["Cakes", "Drinks", "Dish"];
final List<Map<String, dynamic>> menu = [
  {
    "id": "1",
    "name": "Egg Tart",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/eggTart.png"
  },
  {
    "id": "2",
    "name": "UFO Tart",
    "category": "Cakes",
    "price": 2.60,
    "image": "assets/cakes/ufoTart.png"
  },
  {
    "id": "3",
    "name": "HawFlake Cake",
    "category": "Cakes",
    "price": 4.20,
    "image": "assets/cakes/hawFlakeCake.png"
  },
  {
    "id": "4",
    "name": "Vanila Swiss Roll",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/vanilaSwissRoll.png"
  },
  {
    "id": "5",
    "name": "Pandan Swiss Roll",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/pandanSwissRoll.png"
  },
  {
    "id": "6",
    "name": "Coffee Swiss Roll",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/coffeeSwissRoll.png"
  },
  {
    "id": "7",
    "name": "Chocolate Swiss Roll",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/chocolateSwissRoll.png"
  },
  {
    "id": "8",
    "name": "Pandan Swiss Roll",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/pandanSwissRollSpecial.png"
  },
  {
    "id": "9",
    "name": "Chicken Floss",
    "category": "Cakes",
    "price": 3.00,
    "image": "assets/cakes/chickenFloss.png"
  },
  {
    "id": "10",
    "name": "Chicken Pie",
    "category": "Cakes",
    "price": 2.70,
    "image": "assets/cakes/chickenPie.png"
  },
  {
    "id": "11",
    "name": "Jam Pie",
    "category": "Cakes",
    "price": 1.30,
    "image": "assets/cakes/jamPie.png"
  },
  {
    "id": "12",
    "name": "Tausa Pie",
    "category": "Cakes",
    "price": 1.30,
    "image": "assets/cakes/tausaPie.png"
  },
  {
    "id": "13",
    "name": "Choc Cream Cake",
    "category": "Cakes",
    "price": 3.20,
    "image": "assets/cakes/chocCreamCake.png"
  },
  {
    "id": "14",
    "name": "Cream Cake",
    "category": "Cakes",
    "price": 3.20,
    "image": "assets/cakes/creamCake.png"
  },
  {
    "id": "15",
    "name": "Steam Cake",
    "category": "Cakes",
    "price": 2.00,
    "image": "assets/cakes/steamCake.png"
  },
  {
    "id": "16",
    "name": "Cream Puff",
    "category": "Cakes",
    "price": 2.50,
    "image": "assets/cakes/creamPuff.png"
  },
  {
    "id": "17",
    "name": "Curry Puff",
    "category": "Cakes",
    "price": 2.70,
    "image": "assets/cakes/curryPuff.png"
  },
  {
    "id": "18",
    "name": "Custard Cake",
    "category": "Cakes",
    "price": 3.00,
    "image": "assets/cakes/custardCake.png"
  },
  {
    "id": "19",
    "name": "Vanila Custard Cake",
    "category": "Cakes",
    "price": 3.00,
    "image": "assets/cakes/vanilaCustardCake.png"
  },
  {
    "id": "20",
    "name": "Butter Chocolate Cake",
    "category": "Cakes",
    "price": 3.00,
    "image": "assets/cakes/butterChocolateCake.png"
  },
  {
    "id": "21",
    "name": "Honey Comb",
    "category": "Cakes",
    "price": 2.40,
    "image": "assets/cakes/honeyComb.png"
  },
  {
    "id": "22",
    "name": "Cheese Tart",
    "category": "Cakes",
    "price": 3.50,
    "image": "assets/cakes/cheeseTart.png"
  },
  {
    "id": "23",
    "name": "Chocolate Chip",
    "category": "Cakes",
    "price": 4.20,
    "image": "assets/cakes/chocolateChip.png"
  },
  {
    "id": "24",
    "name": "Sponge Cake",
    "category": "Cakes",
    "price": 2.00,
    "image": "assets/cakes/spongeCake.png"
  },
  {
    "id": "50",
    "name": "Teh",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/teh.png",
    "selection": true,
    "choices": [
      {"name": "Teh C", "price": 2.50},
      {"name": "Teh O", "price": 2.50},
      {"name": "Teh Nai", "price": 2.50},
      {"name": "Teh Kahwin", "price": 2.50},
      {"name": "Teh Kosong", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "51",
    "name": "Kopi",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/kopi.png",
    "selection": true,
    "choices": [
      {"name": "Kopi C", "price": 2.50},
      {"name": "Kopi C Kosong", "price": 2.50},
      {"name": "Kopi O", "price": 2.50},
      {"name": "Kopi O Kosong", "price": 2.50},
      {"name": "Kopi Nai", "price": 2.50},
      {"name": "Kopi Kahwin", "price": 2.50},
      {"name": "Kopi Kosong", "price": 2.50},
      {"name": "Kopi Cham C", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "52",
    "name": "Milo",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/milo.png",
    "selection": true,
    "choices": [
      {"name": "Milo C", "price": 2.50},
      {"name": "Milo Nai", "price": 2.50},
      {"name": "Milo Kahwin", "price": 2.50},
      {"name": "Milo Kosong", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "53",
    "name": "Lemon",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/lemon.png",
    "selection": true,
    "choices": [
      {"name": "Lemon Sui", "price": 2.50},
      {"name": "Lemon Teh", "price": 2.50},
      {"name": "Lemon Sui Asam", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "54",
    "name": "Nescafe",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/nescafe.png",
    "selection": true,
    "choices": [
      {"name": "Nescafe C", "price": 2.50},
      {"name": "Nescafe Nai", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "55",
    "name": "Nestum",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
    "selection": true,
    "choices": [
      {"name": "Nestum C", "price": 2.50},
      {"name": "Nestum Nai", "price": 2.50},
      {"name": "Nestum Kahwin", "price": 2.50},
      {"name": "Nestum Kosong", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "56",
    "name": "Kitcai",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
    "selection": true,
    "choices": [
      {"name": "Kitcai Sui", "price": 2.50},
      {"name": "Kitcai Lemon Asam", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "57",
    "name": "Sang Nai Sui",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/example.png",
    "selection": true,
    "choices": [
      {"name": "Sang Nai Sui", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "58",
    "name": "Sang Suk Nai",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/sangSukLai.png",
    "selection": true,
    "choices": [
      {"name": "Sang Suk Nai", "price": 2.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 1.00}
    ]
  },
  {
    "id": "59",
    "name": "Teh C Special",
    "category": "Drinks",
    "price": 4.50,
    "image": "assets/drinks/tehCSpecial.png"
  },
  {
    "id": "63",
    "name": "Liong Fun",
    "category": "Drinks",
    "price": 3.80,
    "image": "assets/drinks/liongFun.png"
  },
  {
    "id": "64",
    "name": "Lo Han Kuo",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/loHanKuo.png"
  },
  {
    "id": "65",
    "name": "Air Bunga",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/example.png"
  },
  {
    "id": "67",
    "name": "Pandan Soy Milk",
    "category": "Drinks",
    "price": 3.00,
    "image": "assets/drinks/pandanSoya.png",
    "selection": true,
    "choices": [
      {"name": "Pandan Soy Milk", "price": 3.00}
    ],
    "types": [
      {"name": "with Sugar", "price": 0.00},
      {"name": "No Sugar", "price": 0.50}
    ]
  },
  {
    "id": "69",
    "name": "Chinese Teh",
    "category": "Drinks",
    "price": 0.50,
    "image": "assets/drinks/chineseTeh.png",
    "selection": true,
    "choices": [
      {"name": "Chinese Teh", "price": 0.50}
    ],
    "types": [
      {"name": "Hot", "price": 0.00},
      {"name": "Cold", "price": 0.00}
    ]
  },
  {
    "id": "71",
    "name": "Lai Lo Fa",
    "category": "Drinks",
    "price": 4.00,
    "image": "assets/drinks/laiLoFa.png"
  },
  {
    "id": "72",
    "name": "100 Plus",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/100Plus.png"
  },
  {
    "id": "73",
    "name": "Coca Cola",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/cocaCola.png"
  },
  {
    "id": "74",
    "name": "EST Cola",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/estCola.png"
  },
  {
    "id": "75",
    "name": "F&N Orange.png",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/F&NOrange.png"
  },
  {
    "id": "76",
    "name": "Yeo's Chrysanthemum",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/chrysanthemum.png"
  },
  {
    "id": "77",
    "name": "Yeo's Susu Soya",
    "category": "Drinks",
    "price": 2.50,
    "image": "assets/drinks/susuSoya.png"
  },
  {
    "id": "101",
    "name": "Kono Mee",
    "category": "Dish",
    "price": 8.00,
    "image": "assets/dish/konoMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam Goreng", "price": 8.00},
      {"name": "Sui Kau", "price": 9.00},
      {"name": "Seafood", "price": 10.00},
      {"name": "Udang", "price": 12.00}
    ]
  },
  {
    "id": "102",
    "name": "Goreng Kering",
    "category": "Dish",
    "price": 9.00,
    "image": "assets/dish/gorengKering.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 9.00},
      {"name": "Ayam", "price": 9.00},
      {"name": "Ayam Goreng", "price": 10.00},
      {"name": "Seafood", "price": 11.00}
    ],
  },
  {
    "id": "103",
    "name": "Goreng Basah",
    "category": "Dish",
    "price": 8.00,
    "image": "assets/dish/gorengBasah.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 8.00},
      {"name": "Ayam", "price": 8.00},
      {"name": "Ayam Goreng", "price": 9.00},
      {"name": "Seafood", "price": 11.00}
    ],
    "types": [
      {"name": "Kuey Teow", "price": 0.00},
      {"name": "Mihun Halus", "price": 0.00},
      {"name": "Mihun Kasar", "price": 0.00},
      {"name": "Mee Kuning", "price": 0.00},
      {"name": "Mee Telur", "price": 0.00},
      {"name": "Yee Mee", "price": 0.00},
    ],
    "meat portion": [
      {"name": "Normal", "price": 0.00},
      {"name": "Extra Meat", "price": 2.00}
    ],
    "mee portion": [
      {"name": "Less Mee", "price": 0.00},
      {"name": "Normal Mee", "price": 0.00},
      {"name": "Extra Mee", "price": 2.00}
    ]
  },
  {
    "id": "104",
    "name": "Laksa",
    "category": "Dish",
    "price": 10.00,
    "image": "assets/dish/laksa.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam Goreng", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00}
    ]
  },
  {
    "id": "105",
    "name": "Lo Mee",
    "category": "Dish",
    "price": 10.00,
    "image": "assets/dish/loMee.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00}
    ]
  },
  {
    "id": "106",
    "name": "Watan Hor",
    "category": "Dish",
    "price": 10.00,
    "image": "assets/dish/watanHor.png",
    "selection": true,
    "choices": [
      {"name": "Campur", "price": 10.00},
      {"name": "Ayam", "price": 10.00},
      {"name": "Sui Kau", "price": 10.00},
      {"name": "Seafood", "price": 12.00}
    ]
  },
  {
    "id": "107",
    "name": "Nasi Ayam",
    "category": "Dish",
    "price": 7.00,
    "image": "assets/dish/nasiAyam.png"
  },
  {
    "id": "108",
    "name": "Nasi Goreng Ayam",
    "category": "Dish",
    "price": 7.00,
    "image": "assets/dish/nasiGorengAyam.png"
  },
  {
    "id": "109",
    "name": "Sui Kau",
    "category": "Dish",
    "price": 9.00,
    "image": "assets/dish/suiKau.png"
  },
];
