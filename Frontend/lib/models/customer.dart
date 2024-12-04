import 'package:ecommerce/models/invoice.dart';

class Customer {
  int? id;
  String? name;
  String? phone;
  List<Invoice>? invoices;

  Customer({
    this.id,
    this.name,
    this.phone,
    this.invoices = const [],
  });

  //for the post method that returns an invoice to match the data sent
  factory Customer.fromPostJson(Map<String, dynamic>? json) {
    return Customer(
      id: json?['id'],
      name: json?['name'],
      phone: json?['phone'],
    );
  }

  // to match DTO
  factory Customer.fromJson(Map<String, dynamic>? json) {
    var invoiceList =
        json?['invoices'] as List? ?? []; //to handle null invoices;
    List<Invoice> invoices =
        invoiceList.map((i) => Invoice.fromSimpleJson(i)).toList();

    return Customer(
        id: json?['id'],
        name: json?['name'],
        phone: json?['phone'], //we need it to when we edit a customer
        invoices: invoices);
  }

  //for the invoice format( to match the DTO form )
  factory Customer.fromSimpleCustomerJson(Map<String, dynamic>? json) {
    return Customer(
      id: json?['customerId'],
      name: json?['customerName'],
    );
  }

  //when sending a customer
  Map<String, dynamic>? toJson() {
    return {
      'id': id, //sometimes we need id, for update for example
      'name': name,
      'phone': phone,
      // 'invoices': invoices?.map((i) => i.toSimpleJson()).toList(),
    };
  }

  //for invoice, since we only need customerId to create, update....
  Map<String, dynamic>? toSimpleCustomerJson() {
    return {'id': id, 'name': name};
  }
}
