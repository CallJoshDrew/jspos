final List<String> categories = [
  "Cakes", "Drinks", "Dish"
];
final List<Map<String, dynamic>> menu = [
  {"id": "1", "name": "Egg Tart", "category": "Cakes", "price": 2.40, "image": "assets/cakes/eggTart.png"},
    { "id": "2", "name": "UFO Tart", "category": "Cakes", "price":2.60, "image": "assets/cakes/ufoTart.png"},
    { "id": "3", "name": "HawFlake Cake", "category": "Cakes", "price":4.20, "image": "assets/cakes/hawFlakeCake.png"},
    { "id": "4", "name": "Vanila Swiss Roll", "category": "Cakes", "price":2.40, "image": "assets/cakes/vanilaSwissRoll.png"},
    { "id": "5", "name": "Pandan Swiss Roll", "category": "Cakes", "price":2.40, "image": "assets/cakes/pandanSwissRoll.png"},
    { "id": "6", "name": "Coffee Swiss Roll", "category": "Cakes", "price":2.40, "image": "assets/cakes/coffeeSwissRoll.png"},
    { "id": "7", "name": "Chocolate Swiss Roll", "category": "Cakes", "price":2.40, "image": "assets/cakes/chocolateSwissRoll.png"},
    { "id": "8", "name": "Pandan Swiss Roll", "category": "Cakes", "price":2.40, "image": "assets/cakes/pandanSwissRollSpecial.png"},
    { "id": "9", "name": "Chicken Floss", "category": "Cakes", "price":3.00, "image": "assets/cakes/chickenFloss.png"},
    { "id": "10", "name": "Chicken Pie", "category": "Cakes", "price":2.70, "image": "assets/cakes/chickenPie.png"},
    { "id": "11", "name": "Jam Pie", "category": "Cakes", "price":1.30, "image": "assets/cakes/jamPie.png"},
    { "id": "12", "name": "Tausa Pie", "category": "Cakes", "price":1.30, "image": "assets/cakes/tausaPie.png"},
    { "id": "13", "name": "Choc Cream Cake", "category": "Cakes", "price":3.20, "image": "assets/cakes/chocCreamCake.png"},
    { "id": "14", "name": "Cream Cake", "category": "Cakes", "price":3.20, "image": "assets/cakes/creamCake.png"},
    { "id": "15", "name": "Steam Cake", "category": "Cakes", "price":2.00, "image": "assets/cakes/steamCake.png"},
    { "id": "16", "name": "Cream Puff", "category": "Cakes", "price":2.50, "image": "assets/cakes/creamPuff.png"},
    { "id": "17", "name": "Curry Puff", "category": "Cakes", "price":2.70, "image": "assets/cakes/curryPuff.png"},
    { "id": "18", "name": "Custard Cake", "category": "Cakes", "price":3.00, "image": "assets/cakes/custardCake.png"},
    { "id": "19", "name": "Vanila Custard Cake", "category": "Cakes", "price":3.00, "image": "assets/cakes/vanilaCustardCake.png"},

    { "id": "20", "name": "Butter Chocolate Cake", "category": "Cakes", "price":3.00, "image": "assets/cakes/butterChocolateCake.png"},
    { "id": "21", "name": "Honey Comb", "category": "Cakes", "price":2.40, "image": "assets/cakes/honeyComb.png"},
    { "id": "22", "name": "Cheese Tart", "category": "Cakes", "price":3.50, "image": "assets/cakes/cheeseTart.png"},
    { "id": "23", "name": "Chocolate Chip", "category": "Cakes", "price":4.20, "image": "assets/cakes/chocolateChip.png"},
    { "id": "24", "name": "Sponge Cake", "category": "Cakes", "price":2.00, "image": "assets/cakes/spongeCake.png"},

    { "id": "50", "name": "Teh", "category": "Drinks", "price":2.50, "image": "assets/drinks/teh.png", "selection":true, "flavor": [{"name": "Teh C"},{"name": "Teh O"},{"name": "Teh Nai"}, {"name": "Teh Kahwin"}, {"name": "Teh Kosong"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "51", "name": "Kopi", "category": "Drinks", "price":2.50, "image": "assets/drinks/kopi.png", "selection":true, "flavor": [{"name": "Kopi C"},{"name": "Kopi C Kosong"}, {"name": "Kopi O"}, {"name": "Kopi O Kosong"}, {"name": "Kopi Nai"}, {"name": "Kopi Kahwin"}, {"name": "Kopi Kosong"}, {"name": "Kopi Cham C"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "52", "name": "Milo", "category": "Drinks", "price":2.50, "image": "assets/drinks/milo.png", "selection":true, "flavor": [{"name": "Milo C"},{"name": "Milo Nai"}, {"name": "Milo Kahwin"}, {"name": "Milo Kosong"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "53", "name": "Lemon", "category": "Drinks", "price":2.50, "image": "assets/drinks/lemon.png", "selection":true, "flavor": [{"name": "Lemon Sui"},{"name": "Lemon Teh"}, {"name": "Lemon Sui Asam"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "54", "name": "Nescafe", "category": "Drinks", "price":2.50, "image": "assets/drinks/nescafe.png", "selection":true, "flavor": [{"name": "Nescafe C"},{"name": "Nescafe Nai"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "55", "name": "Nestum", "category": "Drinks", "price":2.50, "image": "assets/drinks/example.png", "selection":true, "flavor": [{"name": "Nestum C"},{"name": "Nestum Nai"}, {"name": "Nestum Kahwin"}, {"name": "Nestum Kosong"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "56", "name": "Kitcai", "category": "Drinks", "price":2.50, "image": "assets/drinks/example.png", "selection":true, "flavor": [{"name": "Kitcai Sui"},{"name": "Kitcai Lemon Asam"}], "types": [{"name":"Hot", "price": 0.00},{"name":"Cold", "price": 1.00}]},

    { "id": "57", "name": "Sang Nai Sui", "category": "Drinks", "price":2.50, "image": "assets/drinks/example.png", "selection":true, "choices": [{"name": "Hot", "price": 0.00},{"name": "Cold", "price": 1.00}]},

    { "id": "58", "name": "Sang Suk Nai", "category": "Drinks", "price":2.50, "image": "assets/drinks/sangSukLai.png", "selection":true, "choices": [{"name": "Hot", "price": 0.00},{"name": "Cold", "price": 1.00}]},

    { "id": "59", "name": "Teh C Special", "category": "Drinks", "price":4.00, "image": "assets/drinks/tehCSpecial.png", "selection":true, "choices": [{"name": "Hot", "price": 0.00},{"name": "Cold", "price": 0.50}]},

    { "id": "63", "name": "Liong Fun", "category": "Drinks", "price":3.80, "image": "assets/drinks/liongFun.png"},
    { "id": "64", "name": "Lo Han Kuo", "category": "Drinks", "price":3.00, "image": "assets/drinks/loHanKuo.png"},
    { "id": "65", "name": "Air Bunga", "category": "Drinks", "price":3.00, "image": "assets/drinks/example.png"},
    { "id": "67", "name": "Pandan Soy Milk", "category": "Drinks", "price":3.00, "image": "assets/drinks/pandanSoya.png", "selection":true, "choices": [{"name": "with Sugar", "price": 0.00}, {"name": "No Sugar", "price": 0.50}]},
    { "id": "69", "name": "Chinese Teh", "category": "Drinks", "price":0.50, "image": "assets/drinks/chineseTeh.png", "selection":true, "choices": [{"name": "Hot", "price": 0.00},{"name": "Cold", "price": 0.00}]},
    { "id": "71", "name": "Lai Lo Fa", "category": "Drinks", "price":4.00, "image": "assets/drinks/laiLoFa.png"},
    { "id": "72", "name": "100 Plus", "category": "Drinks", "price":2.50, "image": "assets/drinks/100Plus.png"},
    { "id": "73", "name": "Coca Cola", "category": "Drinks", "price":2.50, "image": "assets/drinks/cocaCola.png"},
    { "id": "74", "name": "EST Cola", "category": "Drinks", "price":2.50, "image": "assets/drinks/estCola.png"},
    { "id": "75", "name": "F&N Orange.png", "category": "Drinks", "price":2.50, "image": "assets/drinks/F&NOrange.png"},
    { "id": "76", "name": "Yeo's Chrysanthemum", "category": "Drinks", "price":2.50, "image": "assets/drinks/chrysanthemum.png"},
    { "id": "77", "name": "Yeo's Susu Soya", "category": "Drinks", "price":2.50, "image": "assets/drinks/susuSoya.png"},
    
    { "id": "101", "name": "Kono Mee", "category": "Dish", "price":8.00, "image": "assets/dish/konoMee.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00}, {"name": "Ayam Goreng", "price": 0.00}, {"name": "Sui Kau", "price": 1.00}, {"name": "Seafood", "price": 2.00}, {"name": "Udang", "price": 4.00}]},
    { "id": "102", "name": "Goreng Kering", "category": "Dish", "price":9.00, "image": "assets/dish/gorengKering.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00}, {"name": "Ayam", "price": 0.00}, {"name": "Ayam Goreng", "price": 1.00}, {"name": "Seafood", "price": 2.00}]},

    { "id": "103", "name": "Goreng Basah", "category": "Dish", "price":8.00, "image": "assets/dish/gorengBasah.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00}, {"name": "Ayam", "price": 0.00}, {"name": "Ayam Goreng", "price": 1.00}, {"name": "Seafood", "price": 2.00}], "meat": [{"level":"Normal Meat", "price": 0.00}, {"level":"Extra Meat", "price": 2.00}], "addOn": [{"type":"Normal Mee", "price": 0.00},{"type":"Extra Mee", "price": 2.00}]},

    { "id": "104", "name": "Laksa", "category": "Dish", "price":10.0, "image": "assets/dish/laksa.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00}, {"name": "Ayam Goreng", "price": 0.00}, {"name": "Sui Kau", "price": 0.00}, {"name": "Seafood", "price": 2.00}]},

    { "id": "105", "name": "Lo Mee", "category": "Dish", "price":10.0, "image": "assets/dish/loMee.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00}, {"name": "Ayam", "price": 0.00}, {"name": "Sui Kau", "price": 0.00}, {"name": "Seafood", "price": 2.00}]},

    { "id": "106", "name": "Watan Hor", "category": "Dish", "price":10.00, "image": "assets/dish/watanHor.png", "selection":true, "choices": [{"name": "Campur", "price": 0.00},{"name": "Ayam", "price": 0.00}, {"name": "Sui Kau", "price": 0.00}, {"name": "Seafood", "price": 2.00}]},
    
   
    { "id": "107", "name": "Nasi Ayam", "category": "Dish", "price":7.00, "image": "assets/dish/nasiAyam.png"},
    { "id": "108", "name": "Nasi Goreng Ayam", "category": "Dish", "price":7.00, "image": "assets/dish/nasiGorengAyam.png"},
    { "id": "109", "name": "Sui Kau", "category": "Dish", "price":9.00, "image": "assets/dish/suiKau.png"},
];