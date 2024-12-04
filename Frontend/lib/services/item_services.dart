//used to import http package that contains tools to make http requests, GET, POST...

import 'dart:convert';

import 'package:ecommerce/models/item.dart';
import 'package:http/http.dart' as http;

//this is desined to interact with the backend service that manages items
//it uses http request to fetch data from REST API running on this baseUrl
class ItemService {
  final String baseUrl = "http://localhost:8080/items";

  //asynchronous method, returns a future that will contain a list of items, it accepts the page info because we need them in the Uri
  /* Future<List<Item>> get(int pageNo, int pageSize) async {
    //this sends a GET request to the API to get the items, we give it the uri as we specified it in the endpoint in our backend
    final response =
        //Uri.parse change a string respresentation of Uri to Uri object
        await http.get(Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize'));
    //we validate using the status code
    if (response.statusCode == 200) {
      //this converts the json response body into a dart object, ['content'] is to extract the content of the page (actual list of items)
      //['content'] is the key
      //jsonResponse contains a Map<String, dynamic>, its determined directly by json decode becuase we have a json object
      List jsonResponse = json.decode(response.body)['content'];

      //map iterates over each item in the jsonResponse list
      //Item.fromJson(item) converts each json object into item object using factory constructor
      //then the mapped iterrable is converted back to list
      //jsonResponse is a list of json objects
      //.map iteartes over each 'item' in the 'jsonResponse', it takes each item as pass it to Item.fromJson constructor
      //.map transforms each element in collection from json object to item object
      //the result is an lazy Iterable<Item> then we use .toList to convert it to  a list
      //lazy iterable is a type of iterable where the elements are not fetched until they are actuallt needed
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      
    }
  }*/

  //for the dropdown list
  Future<List<Item>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> get(int pageNo, int pageSize) async {
    //to fetch both paginated items and total nb of items
    final response =
        await http.get(Uri.parse('$baseUrl?pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      List items = jsonResponse['content'];
      int totalItems = jsonResponse['totalElements'];

      return {
        // 'String' : 'dynamic'
        'items': items
            .map((item) => Item.fromJson(item))
            .toList(), //list of item objects
        'totalItems': totalItems //total nb of items
      };
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Item> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Invalid ID, failed to load item');
    }
  }

//Future repsrenets data that will be fetched from a network request
  //its a way to deal with asynchronous operations, it represnets a value that might not be available yet but will be in future
  Future<Item> create(Item item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        //additional info for the server to understand how to process the request
        'Content-Type':
            'application/json; charset=UTF-8' //type of data sent in the body
      },

      //converting the item into a json body
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  //async is used to mark a function as asynchronous, it will return a Future , it can wait for asynchronous operations to complete
  //without blocking the exceution of program
  //async, await, wait until its completed
  Future<void> update(int id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    //Error handling, can be caught later on
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }

  Future<List<Item>> getByName(String name, int pageNo, int pageSize) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/names?name=$name&pageNo=$pageNo&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['content'];
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Name is invalid, failed to get item');
    }
  }
}
