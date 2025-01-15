import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'item.g.dart'; // Name of the generated TypeAdapter file

@HiveType(typeId: 3)
class Item with ChangeNotifier {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final String originalName;
  @HiveField(3)
  final String category;
  @HiveField(4)
  int quantity;
  @HiveField(5)
  double price;
  @HiveField(6)
  final double originalPrice;
  @HiveField(7)
  final String image;
  @HiveField(8)
  final bool selection;
  @HiveField(9)
  List<Map<String, dynamic>> drinks;
  @HiveField(10)
  List<Map<String, dynamic>> choices;
  @HiveField(11)
  List<Map<String, dynamic>> noodlesTypes;
  @HiveField(12)
  List<Map<String, dynamic>> meatPortion;
  @HiveField(13)
  List<Map<String, dynamic>> meePortion;
  @HiveField(14)
  List<Map<String, dynamic>> sides;
  @HiveField(15)
  List<Map<String, dynamic>> addMilk;
  @HiveField(16)
  List<Map<String, dynamic>> addOns;
  @HiveField(17)
  Map<String, dynamic>? _selectedDrink;
  @HiveField(18)
  List<Map<String, String>> temp;
  @HiveField(19)
  Map<String, String>? selectedTemp;
  @HiveField(20)
  Map<String, dynamic>? _selectedChoice;
  @HiveField(21)
  Set<Map<String, dynamic>>? selectedNoodlesType;
  @HiveField(22)
  Map<String, dynamic>? selectedMeatPortion;
  @HiveField(23)
  Map<String, dynamic>? selectedMeePortion;
  @HiveField(24)
  Set<Map<String, dynamic>>? selectedSide;
  @HiveField(25)
  Map<String, dynamic>? selectedAddMilk;
  @HiveField(26)
  Map<String, dynamic>? selectedAddOn;
  @HiveField(27)
  Map<String, dynamic>? itemRemarks;
  @HiveField(28)
  bool tapao;
  @HiveField(29)
  List<Map<String, dynamic>> soupOrKonLou;
  @HiveField(30)
  List<Map<String, dynamic>> setDrinks;
  @HiveField(31)
  Map<String, dynamic>? selectedSoupOrKonLou;
  @HiveField(32)
  Map<String, dynamic>? selectedSetDrink;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.image,
    required this.selection,
    required this.drinks,
    required this.choices,
    required this.noodlesTypes,
    required this.meatPortion,
    required this.meePortion,
    required this.sides,
    required this.addMilk,
    required this.addOns,
    Map<String, dynamic>? selectedDrink,
    required this.temp,
    this.selectedTemp,
    Map<String, dynamic>? selectedChoice,
    this.selectedNoodlesType,
    this.selectedMeatPortion,
    this.selectedMeePortion,
    this.selectedSide,
    this.selectedAddMilk,
    this.selectedAddOn,
    this.itemRemarks,
    this.tapao = false,
    required this.soupOrKonLou,
    required this.setDrinks,
    this.selectedSoupOrKonLou,
    this.selectedSetDrink,
    required this.originalName,
  })  : originalPrice = price,
        _selectedDrink = selectedDrink,
        _selectedChoice = selectedChoice,
        super();

  @override
  String toString() {
    return 'Item: {\n'
        '\tid: $id, \n'
        '\tname: $name, \n'
        '\toriginalname: $originalName, \n'
        '\tprice: $price, \n'
        '\toriginalprice: $originalPrice, \n'
        '\tcategory: $category,\n'
        '\tquantity: $quantity,  \n'
        '\timage: $image, \n'
        '\tselection: $selection, \n'
        '\tdrinks: ${drinks.toString()},\n'
        '\tchoices: ${choices.toString()},\n'
        '\tnoodlesTypes: ${noodlesTypes.toString()},\n'
        '\tmeatPortion: ${meatPortion.toString()},\n'
        '\tmeePortion: ${meePortion.toString()},\n'
        '\tsides: ${sides.toString()},\n'
        '\taddMilk: ${addMilk.toString()},\n'
        '\taddOn: ${addOns.toString()},\n'
        '\tselectedDrink: $selectedDrink, \n'
        '\ttemp: $temp, \n'
        '\tselectedTemp: $selectedTemp, \n'
        '\tselectedChoice: $selectedChoice, \n'
        '\tselectedType: ${selectedNoodlesType?.toString()}, \n'
        '\tselectedMeatPortion: $selectedMeatPortion, \n'
        '\tselectedMeePortion: $selectedMeePortion, \n'
        '\tselectedAddOn: ${selectedSide?.toString()}, \n' // Keep as a Set
        '\tselectedAddMilk: $selectedAddMilk, \n'
        '\tselectedAddOn: $selectedAddOn,\n' // Keep as a Set
        // '\tselectedAddOn: ${selectedAddOn?.map((addOn) => addOn.toString()).join(', ')},\n'
        '\titemRemarks: ${itemRemarks.toString()}\n'
        '\ttapao: $tapao, \n'
        '\tsoupOrKonlou: ${soupOrKonLou.toString()}, \n'
        '\tsetDrinks: ${setDrinks.toString()}, \n'
        '\tselectedSoupOrKonLou: $selectedSoupOrKonLou, \n'
        '\tselectedSetDrink;: $selectedSetDrink;, \n'
        '}';
  }

// Public getters and setters for all properties that should notify listeners
  Map<String, dynamic>? get selectedDrink => _selectedDrink;
  set selectedDrink(Map<String, dynamic>? value) {
    if (_selectedDrink != value) {
      _selectedDrink = value;
      notifyListeners();
    }
  }

  Map<String, dynamic>? get selectedChoice => _selectedChoice;
  set selectedChoice(Map<String, dynamic>? value) {
    if (_selectedChoice != value) {
      _selectedChoice = value;
      notifyListeners();
    }
  }

  // A method to create a copy of the Item
  Item copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    int? quantity,
    String? image,
    bool? selection,
    List<Map<String, dynamic>>? drinks,
    List<Map<String, dynamic>>? choices,
    List<Map<String, dynamic>>? noodlesTypes,
    List<Map<String, dynamic>>? meatPortion,
    List<Map<String, dynamic>>? meePortion,
    List<Map<String, dynamic>>? sides,
    List<Map<String, dynamic>>? addMilk,
    List<Map<String, dynamic>>? addOns,
    Map<String, dynamic>? selectedDrink,
    List<Map<String, String>>? temp,
    Map<String, String>? selectedTemp,
    Map<String, dynamic>? selectedChoice,
    Set<Map<String, dynamic>>? selectedNoodlesType,
    Map<String, dynamic>? selectedMeatPortion,
    Map<String, dynamic>? selectedMeePortion,
    Map<String, dynamic>? selectedAddMilk,
    // Use a Map<String, dynamic> when you want to represent a collection of related data where each item can be uniquely identified by a key. It’s especially useful when you need to handle data in key-value pairs or JSON-like structures (e.g., a user profile or settings configuration).
    Set<Map<String, dynamic>>? selectedSide, 
    // Use Set<Map<String, dynamic>> when you need a collection of unique maps, particularly if you don’t care about the order of the elements and want to ensure there are no duplicates. This could be helpful when storing unique configurations or items that shouldn’t repeat.
    Map<String, dynamic>? selectedAddOn,
    Map<String, dynamic>? itemRemarks,
    bool? tapao,
    List<Map<String, dynamic>>? soupOrKonLou,
    List<Map<String, dynamic>>? setDrinks,
    // Use List<Map<String, dynamic>> when you need an ordered collection of maps, and it’s acceptable for maps to be duplicated. This is useful for data where the order matters, like a list of user profiles, transaction history, or ordered items in a cart.
    Map<String, dynamic>? selectedSoupOrKonLou,
    Map<String, dynamic>? selectedSetDrink,

  // •	Map<String, dynamic>: Use for single objects with key-value pairs (e.g., user settings).
	// •	Set<Map<String, dynamic>>: Use for unique collections where order doesn’t matter (e.g., unique configurations).
	// •	List<Map<String, dynamic>>: Use for ordered collections with possible duplicates (e.g., lists of items or records).
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      originalName: originalName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      selection: selection ?? this.selection,
      drinks: drinks ?? List<Map<String, dynamic>>.from(this.drinks),
      choices: choices ?? List<Map<String, dynamic>>.from(this.choices),
      noodlesTypes: noodlesTypes ?? List<Map<String, dynamic>>.from(this.noodlesTypes),
      meatPortion: meatPortion ?? List<Map<String, dynamic>>.from(this.meatPortion),
      meePortion: meePortion ?? List<Map<String, dynamic>>.from(this.meePortion),
      sides: sides ?? List<Map<String, dynamic>>.from(this.sides),
      addMilk: addMilk ?? List<Map<String, dynamic>>.from(this.addMilk),
      addOns: addOns ?? List<Map<String, dynamic>>.from(this.addOns),
      selectedDrink: selectedDrink ?? (this.selectedDrink != null ? Map<String, dynamic>.from(this.selectedDrink!) : null),
      temp: temp ?? List<Map<String, String>>.from(this.temp),
      selectedTemp: selectedTemp ?? this.selectedTemp,
      selectedChoice: selectedChoice ?? (this.selectedChoice != null ? Map<String, dynamic>.from(this.selectedChoice!) : null),
      selectedNoodlesType: selectedNoodlesType ?? (this.selectedNoodlesType != null ? Set<Map<String, dynamic>>.from(this.selectedNoodlesType!) : null),
      selectedMeatPortion: selectedMeatPortion ?? (this.selectedMeatPortion != null ? Map<String, dynamic>.from(this.selectedMeatPortion!) : null),
      selectedMeePortion: selectedMeePortion ?? (this.selectedMeePortion != null ? Map<String, dynamic>.from(this.selectedMeePortion!) : null),
      selectedSide: selectedSide ?? (this.selectedSide != null ? Set<Map<String, dynamic>>.from(this.selectedSide!) : null),
      selectedAddMilk: selectedAddMilk ?? (this.selectedAddMilk != null ? Map<String, dynamic>.from(this.selectedAddMilk!) : null),
      selectedAddOn: selectedAddOn ?? (this.selectedAddOn != null ? Map<String, dynamic>.from(this.selectedAddOn!) : null),
      itemRemarks: itemRemarks ?? this.itemRemarks, // This ensures the value is set
      tapao: tapao ?? this.tapao,
      soupOrKonLou: soupOrKonLou ?? List<Map<String, dynamic>>.from(this.soupOrKonLou),
      setDrinks: setDrinks ?? List<Map<String, dynamic>>.from(this.setDrinks),
      selectedSoupOrKonLou: selectedSoupOrKonLou ?? (this.selectedSoupOrKonLou != null ? Map<String, dynamic>.from(this.selectedSoupOrKonLou!) : null),
      selectedSetDrink: selectedSetDrink ?? (this.selectedSetDrink != null ? Map<String, dynamic>.from(this.selectedSetDrink!) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalName': originalName,
      'category': category,
      'quantity': quantity,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'selection': selection,
      'drinks': drinks.map((drink) => Map<String, dynamic>.from(drink)).toList(),
      'choices': choices.map((choice) => Map<String, dynamic>.from(choice)).toList(),
      'noodlesTypes': noodlesTypes.map((type) => Map<String, dynamic>.from(type)).toList(),
      'meatPortion': meatPortion.map((portion) => Map<String, dynamic>.from(portion)).toList(),
      'meePortion': meePortion.map((portion) => Map<String, dynamic>.from(portion)).toList(),
      'sides': sides.map((sides) => Map<String, dynamic>.from(sides)).toList(),
      'addMilk': addMilk.map((addMilk) => Map<String, dynamic>.from(addMilk)).toList(),
      'addOns': addOns.map((addon) => Map<String, dynamic>.from(addon)).toList(),
      'selectedDrink': selectedDrink != null ? Map<String, dynamic>.from(selectedDrink!) : null,
      'selectedChoice': selectedChoice != null ? Map<String, dynamic>.from(selectedChoice!) : null,
      'selectedNoodlesType': selectedNoodlesType?.map((noodlesTypes) => Map<String, dynamic>.from(noodlesTypes)).toList(),
      'selectedMeatPortion': selectedMeatPortion != null ? Map<String, dynamic>.from(selectedMeatPortion!) : null,
      'selectedMeePortion': selectedMeePortion != null ? Map<String, dynamic>.from(selectedMeePortion!) : null,
      'selectedSide': selectedSide?.map((sides) => Map<String, dynamic>.from(sides)).toList(), // Convert set to list for JSON
      'selectedAddMilk': selectedAddMilk != null ? Map<String, dynamic>.from(selectedAddMilk!) : null,
      'selectedAddOn': selectedAddOn != null ? Map<String, dynamic>.from(selectedAddOn!) : null,
      // for practical purposes in JSON serialization, as JSON does not support sets.
      'itemRemarks': itemRemarks,
      'tapao': tapao,
      'soupOrKonLou': soupOrKonLou.map((type) => Map<String, dynamic>.from(type)).toList(),
      'setDrinks': setDrinks.map((type) => Map<String, dynamic>.from(type)).toList(),
      'selectedSoupOrKonLou': selectedSoupOrKonLou != null ? Map<String, dynamic>.from(selectedSoupOrKonLou!) : null,
      'selectedSetDrink': selectedSetDrink != null ? Map<String, dynamic>.from(selectedSetDrink!) : null,
    };
  }
}

// {
// Orders
// latest: Orders: [{
// 	orderNumber: #Table1-0001,
// 	tableName: Table 1,
// 	orderType: Dine-In,
// 	status: Placed Order,
// 	items: [
// 		Item: {
// 	id: 2,
// 	name: UFO Tart,
// 	price: 2.6,
// 	category: Cakes,
// 	quantity: 1,
// 	image: assets/cakes/ufoTart.png,
// 	selection: false,
// 	selectedChoice: null,
// 	selectedType: null,
// 	selectedMeatPortion: null,
// 	selectedMeePortion: null
// },
// 		Item: {
// 	id: 3,
// 	name: HawFlake Cake,
// 	price: 4.2,
// 	category: Cakes,
// 	quantity: 1,
// 	image: assets/cakes/hawFlakeCake.png,
// 	selection: false,
// 	selectedChoice: null,
// 	selectedType: null,
//  	selectedMeatPortion: null,
//  	selectedMeePortion: null
//  }
//  	],
//  	subTotal: 6.8,
//  	serviceCharge: 0.0,
//  	totalPrice: 6.8,
//  	quantity: 0,
//  	paymentMethod: Cash,
//  	remarks: No Remarks,
//  	showEditBtn: false
//  }],

// }
// {
// Orders
// latest: Orders: [{
// 	orderNumber: #Table3-0000,
// 	tableName: Table 3,
// 	orderType: Dine-In,
// 	status: Placed Order,
// 	items: [
// 		Item: {
// 	id: 7,
// 	name: Chocolate Swiss Roll,
// 	price: 2.4,
// 	category: Cakes,
// 	quantity: 2,
// 	image: assets/cakes/chocolateSwissRoll.png,
// 	selection: false,
// 	selectedChoice: null,
// 	selectedType: null,
// 	selectedMeatPortion: null,
// 	selectedMeePortion: null
// }
// 	],
// 	subTotal: 4.8,
// 	serviceCharge: 0.0,
// 	totalPrice: 4.8,
// 	quantity: 0,
// 	paymentMethod: Cash,
// 	remarks: No Remarks,
// 	showEditBtn: false
// }, {
// 	orderNumber: #Table3-0000,
// 	tableName: Table 3,
// 	orderType: Dine-In,
// 	status: Placed Order,
//    	items: [
//  		Item: {
//  	id: 7,
//  	name: Chocolate Swiss Roll,
//  	price: 2.4,
//  	category: Cakes,
//  	quantity: 2,
//  	image: assets/cakes/chocolateSwissRoll.png,
//  	selection: false,
//  	selectedChoice: null,
//  	selectedType: null,
//  	selectedMeatPortion: null,
//  	selectedMeePortion: null
//  }
//  	],
//  	subTotal: 4.8,
//  	serviceCharge: 0.0,
//  	totalPrice: 4.8,
//  	quantity: 0,
//  	paymentMethod: Cash,
//  	remarks
// }]}

// I have a flutter app which i need to update the selectedOrder every time. After update it, i also need to save that selectedOrder to the list orders. So orders will keep record of all the orders in different status. Beside that, i also have tables list that keep track of the occupacies and orderNumber associate with the tables. For example:
// After client choose the table, an orderNumber will be created and the status will become "Ordering" The default status is "Start Your Order" and default orderNumber is "Order Number".
// Then client can choose to add items to the selectedOrder.items. There is a section which is responsible to display the selectedOrder object UI. So it will show the latest items added, together with the calculation of the subtotal and total cost.
// After client finished adding the items they want, they can press "Place Order & Print". Then, the selectedOrder.status will become "Placed Order" and items will be added to selectedOrder.items. And then this selectedOrder object will be added to the list orders. The table which has the same orderNumber will have a field "occupied" change to true from false.
// So if let's say we have 3 orders and it all added to the orders list. There is an issue whereby some of the orders have the same orderNumber and table Number. The unexpected behavior is what caused confusion. How to find the real issue and whch code caused this issues?
