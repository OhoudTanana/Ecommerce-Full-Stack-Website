import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/models/invoice_items.dart';

class Invoice {
  int? id;
  double? totalPrice;
  DateTime? orderDate;
  Customer? customer;
  List<InvoiceItems>? invoiceItems;

  Invoice({
    this.id,
    this.totalPrice,
    this.orderDate,
    this.customer,
    this.invoiceItems = const [],
  });

  //for invoice post method
  factory Invoice.fromPostJson(Map<String, dynamic> json) {
    var invoiceItemsList = json['invoiceItems'] as List? ?? [];
    List<InvoiceItems> invoiceItems =
        invoiceItemsList.map((i) => InvoiceItems.fromPostJson(i)).toList();

    return Invoice(
        id: json['id'],
        totalPrice: json['totalPrice']?.toDouble(),
        orderDate: DateTime.parse(json['orderDate']),
        customer: Customer.fromPostJson(json['customer']),
        invoiceItems: invoiceItems);
  }

  //to match invoiceResponse Dto
  factory Invoice.fromJson(Map<String, dynamic>? json) {
    var invoiceItemsList = json?['invoiceItems'] as List? ?? [];
    List<InvoiceItems> invoiceItems = invoiceItemsList
        .map((i) => InvoiceItems.fromSimpleInvoiceItemJson(i))
        .toList();

    Customer customer = Customer(
      id: json?['customerId'],
      name: json?['customerName'],
    );
    return Invoice(
        id: json?['id'],
        totalPrice: json?['totalPrice']?.toDouble(),
        orderDate: DateTime.parse(json?['orderDate']),
        customer: customer,
        invoiceItems: invoiceItems);
  }

  //when we are creating an invoice for example
  Map<String, dynamic>? toJson() {
    return {
      //'id': id,
      //'totalPrice': totalPrice,
      //'orderDate': orderDate?.toIso8601String(),
      'customerId': customer?.id,
      'customerName': customer?.name,
      'invoiceItems': invoiceItems?.map((i) => i.toJson()).toList(),
    };
  }

  /* Map<String, dynamic>? toSimpleJson() {
    return {
      'id': id,
      "orderDate": orderDate?.toIso8601String(),
    };
  }*/

  //for customerInvoiceResponse DTO
  factory Invoice.fromSimpleJson(Map<String, dynamic>? json) {
    return Invoice(
      id: json?['id'],
      orderDate: DateTime.parse(json?['orderDate']),
      //customer: null,
      // invoiceItems: [],
    );
  }
}
