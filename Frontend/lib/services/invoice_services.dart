import 'dart:convert';

import 'package:ecommerce/models/invoice.dart';

import 'package:http/http.dart' as http;

class InvoiceServices {
  final String baseUrl = "http://localhost:8080/invoices";

  /*Future<List<Invoice>> get(int pageNo, int pageSize) async {
    final response =
        await http.get(Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['content'];

      return jsonResponse.map((invoice) => Invoice.fromJson(invoice)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }*/

  Future<Map<String, dynamic>> get(int pageNo, int pageSize) async {
    final response =
        await http.get(Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      List invoices = jsonResponse['content'];
      int totalInvoices = jsonResponse['totalElements'];

      return {
        'invoices':
            invoices.map((invoice) => Invoice.fromJson(invoice)).toList(),
        'totalInvoices': totalInvoices
      };
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  Future<Invoice> create(Invoice invoice) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(invoice.toJson()),
    );

    if (response.statusCode == 201) {
      return Invoice.fromPostJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  Future<void> patch(Invoice invoice, int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(invoice.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update invoice');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete invoice');
    }
  }

  Future<List<Invoice>> getByCustomerId(
      int id, int pageNo, int pageSize) async {
    final response = await http.get(
        Uri.parse('$baseUrl/customers/$id?pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['content'];

      return jsonResponse.map((invoice) => Invoice.fromJson(invoice)).toList();
    } else {
      throw Exception('Failed to load invoices by customer id');
    }
  }

  Future<List<Invoice>> getByCustomerName(
      String name, int pageNo, int pageSize) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/customers?name=$name&pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['content'];

      return jsonResponse.map((invoice) => Invoice.fromJson(invoice)).toList();
    } else {
      throw Exception('Failed to load invoices by customer name');
    }
  }
}
