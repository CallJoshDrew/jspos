class Item {
  String id;
  String name;
  final String category;
  int quantity;
  double price;
  final String image;
  final bool selection;
  Map<String, dynamic>? selectedChoice;
  Map<String, dynamic>? selectedType;
  Map<String, dynamic>? selectedMeatPortion;
  Map<String, dynamic>? selectedMeePortion;

  Item({
    required this.id, 
    required this.name, 
    required this.category, 
    required this.quantity, 
    required this.price, 
    required this.image, 
    this.selection = false, 
    this.selectedChoice, 
    this.selectedType,
    this.selectedMeatPortion,
    this.selectedMeePortion,
  });

  @override
  String toString() {
    return 'Item: {\n\tid: $id, \n\tname: $name, \n\tprice: $price, \n\tcategory: $category,\n\tquantity: $quantity,  \n\timage: $image, \n\tselection: $selection, \n\tselectedChoice: $selectedChoice, \n\tselectedType: $selectedType, \n\tselectedMeatPortion: $selectedMeatPortion, \n\tselectedMeePortion: $selectedMeePortion\n}';
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