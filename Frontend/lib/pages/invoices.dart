import 'package:ecommerce/models/invoice.dart';
import 'package:ecommerce/services/invoice_services.dart';
import 'package:ecommerce/widgets/head_bar.dart';
import 'package:ecommerce/widgets/invoice_details.dart';
import 'package:ecommerce/widgets/invoice_form.dart';
import 'package:ecommerce/widgets/invoice_search.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final InvoiceServices invoiceServices = InvoiceServices();

  List<Invoice> _invoices = [];

  bool loading = true;

  //paging
  int totalInvoices = 0;
  int currentPage = 0;
  int invoicesPerPage = 1;

  int get nbOfPages => (totalInvoices / invoicesPerPage).ceil();

  @override
  void initState() {
    super.initState();
    //fetch the initial list of items
    getInvoices(currentPage);
  }

  getInvoices(int page) async {
    // print('fetching invoices...');
    try {
      final response = await invoiceServices.get(page, invoicesPerPage);
      // print('Fetched invoices: $invoices');
      List<Invoice> invoices = response['invoices'];
      int total = response['totalInvoices'];

      setState(() {
        _invoices = invoices;
        totalInvoices = total;
        loading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> getByCustomerId(int id) async {
    try {
      List<Invoice> invoices = await invoiceServices.getByCustomerId(id, 0, 10);

      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => InvoiceSearch(
                    invoices: invoices,
                    onDelete: deleteInvoice,
                    onUpdate: updateInvoice,
                  )));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer ID is invalid')),
      );
    }
  }

  Future<void> getByCustomerName(String name) async {
    try {
      List<Invoice> invoices =
          await invoiceServices.getByCustomerName(name, 0, 10);

      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => InvoiceSearch(
                    invoices: invoices,
                    onDelete: deleteInvoice,
                    onUpdate: updateInvoice,
                  )));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer name is invalid')),
      );
    }
  }

  //those are used for the state of UI, to reflect any changes that we performed on the list, to be shown directly
  updateInvoice(Invoice updatedInvoice) {
    //get the customer from the list
    setState(() {
      final index =
          _invoices.indexWhere((invoice) => invoice.id == updatedInvoice.id);

      if (index != -1) {
        _invoices[index] = updatedInvoice;
      }
    });
  }

  deleteInvoice(int id) {
    setState(() {
      _invoices.removeWhere((invoice) => invoice.id == id);

      totalInvoices--;

      //because if i deleted an element from last page and its empty, it crashes
      //if this condition is true , it means that the current page no longer exists
      if (currentPage >= nbOfPages) {
        //if nb of pages +ve then we set nbOfPages to nbofpages-1 else, we no more have pages so we set it to 0
        currentPage = nbOfPages > 0 ? nbOfPages - 1 : 0;
      }
      getInvoices(currentPage);
    });
  }

  addInvoice(Invoice invoice) {
    setState(() {
      _invoices.add(invoice);

      totalInvoices++;

      getInvoices(currentPage);
    });
  }

  /* _showSearch(String searchType) {
    if (searchType == 'ID') {
      showSearch(
        context: context,
        delegate: CustomerSearchByIdDelegate(onSearchId: getByCustomerId),
      );
    } else if (searchType == 'Name') {
      showSearch(
          context: context,
          delegate:
              CustomerSearchByNameDelegate(onSearchName: getByCustomerName));
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadBar(
        title: "Invoices ",
        action: Tooltip(
            message: 'Search by name',
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
              onPressed: () => showSearch(
                  context: context,
                  delegate: CustomerSearchByNameDelegate(
                      onSearchName: getByCustomerName)),
            )),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _invoices.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(_invoices[index].customer?.name ?? 'no name'),
                        subtitle: Text(
                            _invoices[index].customer?.id.toString() ??
                                'no id'),
                        textColor: const Color.fromARGB(255, 110, 39, 63),
                        titleTextStyle: const TextStyle(fontSize: 25),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoiceDetails(
                                invoice: _invoices[index],
                                onDelete: deleteInvoice,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                NumberPaginator(
                    numberPages: nbOfPages, //dynamically set nb of pages
                    initialPage: currentPage,
                    onPageChange: (index) {
                      setState(() {
                        currentPage = index; //update current page
                      });
                      getInvoices(
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
                builder: (context) => InvoiceForm(
                  onCreate: addInvoice,
                  onUpdate: updateInvoice,
                ),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 241, 177, 199),
          foregroundColor: Colors.white,
          tooltip: "Create new invoice",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/*class CustomerSearchByIdDelegate extends SearchDelegate<String> {
  final Function(int) onSearchId;

  CustomerSearchByIdDelegate({required this.onSearchId})
      : super(searchFieldLabel: 'Search invoice by customer id');

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
      : super(searchFieldLabel: 'Search invoice by customer name');

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
