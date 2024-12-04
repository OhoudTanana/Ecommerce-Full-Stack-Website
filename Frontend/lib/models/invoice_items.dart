import 'package:ecommerce/models/invoice.dart';
import 'package:ecommerce/models/item.dart';

class InvoiceItems {
  int? id;
  int? quantity;
  double? totalPrice;
  Invoice? invoice;
  Item? item;

  InvoiceItems(
      {this.id, this.quantity, this.totalPrice, this.invoice, this.item});

  //for the post of invoice
  factory InvoiceItems.fromPostJson(Map<String, dynamic>? json) {
    return InvoiceItems(
        id: json?['id'],
        quantity: json?['quantity'],
        totalPrice: json?['totalPrice'],
        item: Item.fromJson(json?['item']));
  }

  /*factory InvoiceItems.fromJson(Map<String, dynamic>? json) {
    return InvoiceItems(
        id: json?['id'],
        quantity: json?['quantity'],
        totalPrice: json?['totalPrice'],
        invoice: Invoice.fromJson(json?['invoice']),
        item: Item.fromJson(json?['item']));
  }*/

  //for invoice
  Map<String, dynamic> toJson() {
    return {
      'itemId': item?.id,
      'itemName': item?.name,
      'quantity': quantity,
    };
  }

  //for invoice
  factory InvoiceItems.fromSimpleInvoiceItemJson(Map<String, dynamic>? json) {
    Item item = Item(
      id: json?['itemId'],
      name: json?['itemName'],
      price: json?['itemPrice'],
    );

    return InvoiceItems(quantity: json?['quantity'], item: item);
  }

  /*Map<String, dynamic>? toSimpleInvoiceItemJson() {
    return {
      'quantity': quantity,
      'itemId': item?.id,
      'itemName': item?.name,
      'itemPrice': item?.price,
    };
  }*/
}
