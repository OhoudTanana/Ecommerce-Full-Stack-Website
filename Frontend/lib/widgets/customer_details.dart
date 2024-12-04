import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/services/customer_services.dart';
import 'package:ecommerce/widgets/customer_form.dart';
import 'package:flutter/material.dart';

class CustomerDetails extends StatefulWidget {
  //sent from parent widget(customer page)
  final Customer customer;

  //in case customer was updated or deleted
  final Function(int)? onDelete;
  final Function(Customer)? onUpdate;

  const CustomerDetails(
      {super.key, required this.customer, this.onDelete, this.onUpdate});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late Customer customer;
  final CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
  }

  updateCustomer(Customer updatedCustomer) {
    setState(() {
      customer = updatedCustomer;
    });

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedCustomer); //notifies the parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          customer.name ?? 'no name',
          style: const TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ID: ${customer.id}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Name:${customer.name}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 20),
              const Text('Invoices:',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 110, 39, 63),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap:
                      true, // make the list view take only the needed space
                  itemCount: customer.invoices?.length,
                  itemBuilder: (context, index) {
                    final invoice = customer.invoices?[index];
                    return ListTile(
                      title: Text(
                        'Invoice ID: ${invoice?.id}',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 110, 39, 63)),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        'Order Date: ${invoice?.orderDate}',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 110, 39, 63)),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      //this is expected to return a customer after the path is popped(when we submit the form)
                      final updatedCustomer = await Navigator.push<Customer>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerForm(
                            customer:
                                customer, //current customer is passed as an argument
                            onUpdate:
                                updateCustomer, //updateCustomer is passed and will be called inside form when customer is updated
                            //this allows customerForm to notify current widget when the customer has been updated
                          ),
                        ),
                      );

                      if (updatedCustomer != null) {
                        updateCustomer(
                            updatedCustomer); //update customer in the current widget, state of current, refresh UI
                      }
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await customerService.delete(customer.id!);

                      if (widget.onDelete != null) {
                        widget.onDelete!(customer.id!);
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text('Delete', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
