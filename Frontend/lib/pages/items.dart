import 'package:ecommerce/models/item.dart';
import 'package:ecommerce/services/item_services.dart';
import 'package:ecommerce/widgets/head_bar.dart';
import 'package:ecommerce/widgets/item_details.dart';
import 'package:ecommerce/widgets/item_form.dart';
import 'package:ecommerce/widgets/item_search.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPage();
}

class _ItemsPage extends State<ItemsPage> {
  //list of items fetched from the service
  final ItemService itemService = ItemService();

  List<Item> _items = [];
//to know if the items are still being fetched from the backend
  bool loading = true;

  //paging
  int totalItems = 0; //total nb of items in backend
  int itemsPerPage = 1; //nb of items to show in page
  int currentPage = 0; //current page

  //getter that calculates the total nb of pages
  int get numberOfPages =>
      (totalItems / itemsPerPage).ceil(); //calculate total pages

  @override
  void initState() {
    super.initState();
    //fetch the initial list of items
    getItems(currentPage); //fetch 1st page of items on initialization
  }

  //fetch items for a specific page
  getItems(int page) async {
    try {
      //fetches a page from service
      //List<Item> items = await itemService.get(0, 10);

      var response = await itemService.get(page, itemsPerPage);
      List<Item> items = response['items'];
      int total = response['totalItems'];

      setState(() {
        _items = items;
        totalItems = total;
        loading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  updateItem(Item updatedItem) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
      }
    });
  }

  /* getItemById(int id) async {
    try {
      Item item = await itemService.getById(id);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetail(
            item: item,
            onDelete: deleteItem,
            onUpdate: updateItem,
          ),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item ID is not valid')),
      );
    }
  }*/

  getItemByName(String name) async {
    try {
      List<Item> items = await itemService.getByName(name, 0, 10);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ItemSearch(
              items: items, onUpdate: updateItem, onDelete: deleteItem),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error fetching items')));
    }
  }

  deleteItem(int id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
      totalItems--;

      //because if i deleted an element from last page and its empty, it crashes
      //if this condition is true , it means that the current page no longer exists
      if (currentPage >= numberOfPages) {
        //if nb of pages +ve then we set nbOfPages to nbofpages-1 else, we no more have pages so we set it to 0
        currentPage = numberOfPages > 0 ? numberOfPages - 1 : 0;
      }
      getItems(currentPage);
    });
  }

  addItem(Item item) {
    setState(() {
      _items.add(item);

      totalItems++;

      getItems(currentPage);
    });
  }

  /*void _showSearch(String searchType) {
    if (searchType == 'ID') {
      //a flutter function that allows us to display a search page or a search interface, onpressed is the callback trigger
      showSearch(
        context: context,
        //delegate is an instance of class that extends SearchDelegate, it defines the search behavoir, what to display when searching and how to handle search results
        //onSearch will be called when a valid ID is entered
        //onSearch will be set to the value provided after :
        //searchById should match Function(int) that we defined onSearch with
        delegate: ItemSearchByIdDelegate(onSearchById: getItemById),
      );
    } else if (searchType == 'Name') {
      showSearch(
        context: context,
        delegate: ItemSearchByNameDelegate(onSearchByName: getItemByName),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        title: "Items",
        action: Tooltip(
          message: 'Search',
          child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
              onPressed: () => showSearch(
                  context: context,
                  delegate:
                      ItemSearchByNameDelegate(onSearchByName: getItemByName))),
        ),
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator()) //this will show loading spinner centered at the center of the screen
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_items[index].name ?? 'no name'),
                        textColor: const Color.fromARGB(255, 110, 39, 63),
                        titleTextStyle: const TextStyle(fontSize: 25),
                        subtitle:
                            Text(_items[index].description ?? 'no description'),
                        onTap: () {
                          //gets triggered when the user press on the items in list
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetail(
                                item: _items[index],
                                onDelete: deleteItem,
                                onUpdate: updateItem,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                NumberPaginator(
                    numberPages: numberOfPages, //dynamically set nb of pages
                    initialPage: currentPage,
                    onPageChange: (index) {
                      setState(() {
                        currentPage = index; //update current page
                      });
                      getItems(currentPage); //fetch items for the selected page
                    })
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemForm(
                  onItemCreated: addItem,
                  onItemUpdated: updateItem,
                ),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 241, 177, 199),
          foregroundColor: Colors.white,
          tooltip: "Create new item",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

//this class is responsible for defining the search interface and handling the search query when the user interacts with the search UI
//by using int we specify what kind of data our search operation is goign to return as result
//since its search by id, then int, if by name <String>
//the type of result that will be returned when search operation is complete
/*class ItemSearchByIdDelegate extends SearchDelegate<String> {
  //this works as the holder for the actual function that is goign to be passed (searchByItem) that is going to actually perform the logic
  final Function(int) onSearchById;

  //Constructor
  //we use : to call the constructor of the super class SearchDelegate... before the body of the current constructor
  ItemSearchByIdDelegate({required this.onSearchById})
      : super(searchFieldLabel: 'Search item by ID');

  //this defines the actions that appears on the right side of the search bar
  //we placed in it a clear button (x) when we write a word it can be erased and we start over
  //to start a new search
  @override
  List<Widget> buildActions(context) {
    //list beacause it may hold many actions
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  //this appears on the left side of the search bar
  //its typically used to exit the search
  //an arrow back icon
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        //when pressed it closes the search interface without returning a result, we can return a result and catch it in
        //return result of showSearch, beacuse its the method that called it
        // if string, ' ' we return instead
        close(context, '');
      },
    );
  }

//this method is triggered when the user submits the search query
  @override
  Widget buildResults(BuildContext context) {
    //parse the query into int
    //query  is a built in proprty provided by SearchDelegate class itself, it represents the current text input in the search field
    //ex: if i typed 6, it will be sent as a string '6', try parse will convert it to 6, beacuse its a valid integer
    //if wrong format it wont be able to convert it so id will be null
    final int? id = int.tryParse(query);

    //if successfull
    if (id != null) {
      //closes the search interface
      close(context, '');
      //calls the onSearch funtion
      onSearchById(id);
    } else {
      //here if the user entered letters instead of numbers
      //the ID that are not found in db but with correct format will be caught in searchById method
      return const Center(child: Text('Invalid ID format'));
    }

    return Container();
  }

  //this is responsible for showing search suggestions as the user tyoe their query, here nothing will be returned
  @override
  Widget buildSuggestions(BuildContext context) {
    //no suggestions will be shown
    return Container();
  }
}*/

class ItemSearchByNameDelegate extends SearchDelegate<String> {
  final Function(String) onSearchByName;

  ItemSearchByNameDelegate({required this.onSearchByName})
      : super(searchFieldLabel: 'Search item by Name');

  @override
  List<Widget> buildActions(context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        close(context, '');
        onSearchByName(query);
      });
    } else {
      return const Center(child: Text('Please enter a name'));
    }

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
