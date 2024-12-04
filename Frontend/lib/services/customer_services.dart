import 'dart:convert';
import 'package:ecommerce/models/customer.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  final String baseUrl = "http://localhost:8080/customers";

  /*Future<List<Customer>> get(int pageNo, int pageSize) async {
    final response =
        await http.get(Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['content'];

      return jsonResponse
          .map((customer) => Customer.fromJson(customer))
          .toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }*/

  /*Future<List<Customer>> getAllOrName(
      int pageNo, int pageSize, String? name) async {
    final url = name != null
        ? '$baseUrl/all?name=$name&pageNo=$pageNo&pageSize=$pageSize'
        : '$baseUrl/all?pageNo=$pageNo&pageSize=$pageSize';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['content'];

      return jsonResponse
          .map((customer) => Customer.fromJson(customer))
          .toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }*/

  Future<Map<String, dynamic>> getAllOrName(
      int pageNo, int pageSize, String? name) async {
    final url = name != null
        ? '$baseUrl/all?name=$name&pageNo=$pageNo&pageSize=$pageSize'
        : '$baseUrl/all?pageNo=$pageNo&pageSize=$pageSize';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      List customers = jsonResponse['content'];
      int totalCustomers = jsonResponse['totalElements'];

      return {
        'customers':
            customers.map((customer) => Customer.fromJson(customer)).toList(),
        'totalCustomers': totalCustomers
      };
    } else {
      throw Exception('Failed to load customers');
    }
  }

  //for the dropdown
  Future<List<Customer>> get() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse
          .map((customer) => Customer.fromJson(customer))
          .toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Invalid ID, failed to load Customer');
    }
  }

  /* Future<List<Customer>> getByName(
      String name, int pageSize, int pageNo) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/names?name=$name&pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['content'];

      return jsonResponse
          .map((customer) => Customer.fromJson(customer))
          .toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }*/

  /*Future<Customer> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Invalid ID, failed to load customer');
    }
  }*/

  Future<Customer> create(Customer customer) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<void> update(int id, Customer customer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }
}
