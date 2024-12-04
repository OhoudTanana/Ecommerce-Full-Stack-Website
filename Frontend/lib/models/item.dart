//this class represents the item entity
//its used to handle item data, that are fetched from or sent to a backend

//names should match entities and data to ensure proper serialization and deserialization of data
//fromJson method should match the JSON keys we send in postman for example , then the method will map these keys to
//the respective dart model attributes
//same for toJson method

class Item {
  //attributes
  int? id; //beacuse its auto generated
  String? name;
  String? description;
  double? price;
  int? stock;

//constructor
  Item({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
  });

  //special kind of constructors in dart, they are not used to initailze an instance directly, instead they can return an isntnce of class or another one
//we can do validations inside it before sending it, or tranformation
//here it creates an item object from JSON map
//in the context of JSON parsing, a factory constructor is commonly used to create an instance of a class
//factory constructor for json parsing
//factory Item.fromJson.. a factory constructor that creates an item instance from json map
//json map contains data received from an API
//returns an item object initialzed with values from json map

//(Map<String, dynamic> json
//dynamic type means that the values can be of any type in the map

  factory Item.fromJson(Map<String, dynamic>? json) {
    return Item(
        id: json?['id'],
        name: json?['name'],
        description: json?['description'],
        price: json?['price'],
        stock: json?['stock']);
  }

//method to convert to json
//convert the item into json map
//returns a map where each key value pair corresponds to the properties of item class
  Map<String, dynamic>? toJson() {
    return {
      //'key' : value
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
    };
  }

  //for invoice
  factory Item.fromSimpleItem(Map<String, dynamic>? json) {
    return Item(
        id: json?['itemId'],
        name: json?['itemName'],
        price: json?['itemPrice']);
  }

  //for invoice
  Map<String, dynamic>? toSimpleItemJson() {
    return {'itemId': id, 'itemName': name};
  }
}
