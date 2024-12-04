import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/widgets/customer_details.dart';
import 'package:flutter/material.dart';

class CustomerSearch extends StatefulWidget {
  final List<Customer> customers;

  final Function(int)? onDelete;
  final Function(Customer)? onUpdate;

  const CustomerSearch(
      {super.key, required this.customers, this.onDelete, this.onUpdate});

  @override
  State<CustomerSearch> createState() => _CustomerSearchState();
}

class _CustomerSearchState extends State<CustomerSearch> {
  late List<Customer> _searchCustomers;

  @override
  void initState() {
    super.initState();
    _searchCustomers = List.from(widget.customers);
  }

  updateItem(Customer updatedCustomer) {
    setState(() {
      final index = _searchCustomers
          .indexWhere((customer) => customer.id == updatedCustomer.id);
      if (index != -1) {
        _searchCustomers[index] = updatedCustomer;
      }
    });

    widget.onUpdate!(updatedCustomer);
  }

  deleteItem(int id) {
    setState(() {
      _searchCustomers.removeWhere((customer) => customer.id == id);
    });

    widget.onDelete!(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customers',
          style: TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: ListView.builder(
        itemCount: _searchCustomers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchCustomers[index].name ?? 'no name'),
            textColor: const Color.fromARGB(255, 110, 39, 63),
            titleTextStyle: const TextStyle(fontSize: 25),
            onTap: () async {
              final response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDetails(
                    customer: _searchCustomers[index],
                    onUpdate: updateItem,
                    onDelete: deleteItem,
                  ),
                ),
              );

              if (response != null) {
                if (response is int) {
                  widget.onDelete!(response);
                } else {
                  widget.onUpdate!(response);
                }
              }
              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}
