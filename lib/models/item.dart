import 'package:hive/hive.dart';

part 'item.g.dart';  // Name of the generated TypeAdapter file

@HiveType(typeId: 2)
class Item {
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
  List<Map<String, dynamic>> choices;
  @HiveField(10)
  List<Map<String, dynamic>> types;
  @HiveField(11)
  List<Map<String, dynamic>> meatPortion;
  @HiveField(12)
  List<Map<String, dynamic>> meePortion;
  @HiveField(14)
  List<Map<String, dynamic>> addOn;
  @HiveField(15)
  Map<String, dynamic>? selectedChoice;
  @HiveField(16)
  Map<String, dynamic>? selectedType;
  @HiveField(17)
  Map<String, dynamic>? selectedMeatPortion;
  @HiveField(18)
  Map<String, dynamic>? selectedMeePortion;
  @HiveField(19)
  Set<Map<String, dynamic>>? selectedAddOn;
  @HiveField(20)
  Map<String, dynamic>? itemRemarks;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.image,
    this.selection = false,
    required this.choices,
    required this.types,
    required this.meatPortion,
    required this.meePortion,
    required this.addOn,
    this.selectedChoice,
    this.selectedType,
    this.selectedMeatPortion,
    this.selectedMeePortion,
    this.selectedAddOn,
    this.itemRemarks, 
    required this.originalName,
  })  : originalPrice = price;

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
      '\tchoices: ${choices.toString()},\n'
      '\ttypes: ${types.toString()},\n'
      '\tmeatPortion: ${meatPortion.toString()},\n'
      '\tmeePortion: ${meePortion.toString()},\n'
      '\taddOn: ${addOn.toString()},\n'
      '\tselectedChoice: $selectedChoice, \n'
      '\tselectedType: $selectedType, \n'
      '\tselectedMeatPortion: $selectedMeatPortion, \n'
      '\tselectedMeePortion: $selectedMeePortion,\n'
      '\tselectedAddOn: ${selectedAddOn?.map((addOn) => addOn.toString()).join(', ')},\n'
      '\titemRemarks: ${itemRemarks.toString()}\n'
      '}';
}


  // A method to create a copy of the Item
  Item copyWith({Map<String, dynamic>? itemRemarks}) {
    return Item(
      id: id,
      name: name,
      originalName: originalName,
      category: category,
      quantity: quantity,
      price: price,
      image: image,
      selection: selection,
      choices: choices,
      types: types,
      meatPortion: meatPortion,
      meePortion: meePortion,
      addOn: addOn,
      selectedChoice: selectedChoice != null ? Map<String, dynamic>.from(selectedChoice!) : null,
      selectedType: selectedType != null ? Map<String, dynamic>.from(selectedType!) : null,
      selectedMeatPortion: selectedMeatPortion != null ? Map<String, dynamic>.from(selectedMeatPortion!) : null,
      selectedMeePortion: selectedMeePortion != null ? Map<String, dynamic>.from(selectedMeePortion!) : null,
      selectedAddOn: selectedAddOn != null ? Set<Map<String, dynamic>>.from(selectedAddOn!) : null,
      itemRemarks: itemRemarks,
    );
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