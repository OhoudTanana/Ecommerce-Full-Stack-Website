import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/services/customer_services.dart';
import 'package:ecommerce/widgets/customer_details.dart';
import 'package:ecommerce/widgets/customer_form.dart';
import 'package:ecommerce/widgets/customer_search.dart';
import 'package:ecommerce/widgets/head_bar.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final CustomerService customerService = CustomerService();

  late List<Customer> _customers = [];

  bool loading = true;

  //paging

  //the page we are in
  int currentPage = 0;

  //how many customer is allowed in each page
  int customersPerPage = 1;

  //totalCustomers fetched from backend
  int totalCustomers = 0;

  //its a getter, we are calculating the nb of pages, for the NumberPaginator
  int get numberOfPages => (totalCustomers / customersPerPage).ceil();

  @override
  void initState() {
    super.initState();

    //fetched page 0
    getCustomers(currentPage);
  }

  //i added int page, we fetch each page alone and remove the old data from memory
  getCustomers(int page) async {
    try {
      final response =
          await customerService.getAllOrName(page, customersPerPage, null);

      //customers
      List<Customer> customers = response['customers'];

      //total nb of customers
      int total = response['totalCustomers'];

      //with each fetch we update the list of customers that is shown and the total nb of customers in case we added or deleted any
      setState(() {
        _customers = customers;
        totalCustomers = total;
        loading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /* getCustomerById(int id) async {
    try {
      Customer customer = await customerService.getById(id);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => CustomerDetails(
            customer: customer,
            onDelete: deleteCustomer,
            onUpdate: updateCustomer,
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

  getCustomerByName(String name) async {
    try {
      final response = await customerService.getAllOrName(0, 10, name);

      List<Customer> customer = response['customers'];

      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => CustomerSearch(
                    customers: customer,
                    onDelete: deleteCustomer,
                    onUpdate: updateCustomer,
                  )));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer name is invalid')),
      );
    }
  }

  //those are used for the state of UI, to reflect any changes that we performed on the list, to be shown directly
  updateCustomer(Customer updatedCustomer) {
    //get the customer from the list
    setState(() {
      final index = _customers
          .indexWhere((customer) => customer.id == updatedCustomer.id);

      if (index != -1) {
        _customers[index] = updatedCustomer;
      }
    });
  }

  deleteCustomer(int id) {
    //called to inform flutter that the state of widget has changed to rebuild UI
    setState(() {
      //removes customer from list
      _customers.removeWhere((customer) => customer.id == id);

      //decrement total count
      //evernthough we are going to refetch, but this keeps a consistent user interface and to help in pagination logic
      //in this way we see imediate changes before waiting for network request
      totalCustomers--;

      //because if i deleted an element from last page and its empty, it crashes
      //if this condition is true , it means that the current page no longer exists
      if (currentPage >= numberOfPages) {
        //if nb of pages +ve then we set nbOfPages to nbofpages-1 else, we no more have pages so we set it to 0
        currentPage = numberOfPages > 0 ? numberOfPages - 1 : 0;
      }

      //to reflect most curretn data
      getCustomers(currentPage);
    });
  }

  addCustomer(Customer customer) {
    setState(() {
      //adding customer to the list
      _customers.add(customer);

      //adding nb of customers
      totalCustomers++;

      //getting the customer again to update the UI
      getCustomers(currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        title: "Customers ",
        action: Tooltip(
            message: 'Search by name',
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CustomerSearchByNameDelegate(
                      onSearchName: getCustomerByName)),
            )),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _customers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_customers[index].name ?? 'no name'),
                        textColor: const Color.fromARGB(255, 110, 39, 63),
                        titleTextStyle: const TextStyle(fontSize: 25),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerDetails(
                                customer: _customers[index],
                                onDelete: deleteCustomer,
                                onUpdate: updateCustomer,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                //this shows the numbered buttons at the bottom
                NumberPaginator(
                    numberPages: numberOfPages, //dynamically set nb of pages
                    initialPage: currentPage,
                    onPageChange: (index) {
                      //when we navigate to other page
                      setState(() {
                        currentPage = index; //update current page
                      });
                      getCustomers(
                          currentPage); //fetch items for the selected page
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
                builder: (context) => CustomerForm(
                  onCreate: addCustomer,
                  onUpdate: updateCustomer,
                ),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 241, 177, 199),
          foregroundColor: Colors.white,
          tooltip: "Create new customer",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/*class CustomerSearchByIdDelegate extends SearchDelegate<String> {
  final Function(int) onSearchId;

  CustomerSearchByIdDelegate({required this.onSearchId})
      : super(searchFieldLabel: 'Search customer by id');

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int? id = int.tryParse(query);

    if (id != null) {
      //to avoid crash, it avoids setting any state while there is other widget tree in the process of building
      WidgetsBinding.instance.addPostFrameCallback((_) {
        close(context, ''); //becuase this calls navigator.pop
        onSearchId(id);
      });
    } else {
      return const Center(child: Text('Customer ID is invalid'));
    }

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}*/

class CustomerSearchByNameDelegate extends SearchDelegate<String> {
  final Function(String) onSearchName;

  CustomerSearchByNameDelegate({required this.onSearchName})
      : super(searchFieldLabel: 'Search customer by Name');

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
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
      //this ensures that any interaction with widget tree, happen after the UI is stable and rendred
      WidgetsBinding.instance.addPostFrameCallback((_) {
        close(context, '');
        onSearchName(query);
      });
    } else {
      return const Center(child: Text('Customer Name is invalid'));
    }

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
