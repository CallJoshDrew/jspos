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