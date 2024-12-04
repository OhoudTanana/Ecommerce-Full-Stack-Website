import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/services/customer_services.dart';
import 'package:flutter/material.dart';

class CustomerForm extends StatefulWidget {
  final Customer? customer;
  final Function(Customer)? onUpdate;
  final Function(Customer)? onCreate;

  const CustomerForm({super.key, this.customer, this.onUpdate, this.onCreate});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final CustomerService customerService = CustomerService();

  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _idController =
        TextEditingController(text: widget.customer?.id.toString() ?? '');
    _nameController = TextEditingController(text: widget.customer?.name ?? '');

    _phoneController =
        TextEditingController(text: widget.customer?.phone ?? '');
  }

  //called to clean resources after widget is removed from widget tree
  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final customer = Customer(
        id: widget.customer?.id, //the existing value
        name: _nameController.text,
        phone: _phoneController.text,
        invoices: widget.customer?.invoices,
      );

      if (widget.customer != null) {
        await customerService.update(widget.customer!.id!, customer);
        widget.onUpdate!(customer);
      } else {
        Customer createdCustomer = await customerService.create(customer);
        widget.onCreate!(createdCustomer);

        // ignore: use_build_context_synchronously
        Navigator.pop(context, createdCustomer);
        return;
      }

      //ensures that we are reacting with the widget only if its active
      if (mounted) {
        //this helps prevent interacting with a disposed widget
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer != null ? 'Edit Customer' : 'New Customer',
            style: const TextStyle(color: Color.fromARGB(255, 110, 39, 63))),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Display ID (Optional)
              if (widget.customer != null)
                TextFormField(
                  style:
                      const TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
                  controller: _idController,
                  decoration: const InputDecoration(
                      labelText: 'ID',
                      labelStyle: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 110, 39, 63))),
                  enabled: false, // Make ID field read-only
                ),
              TextFormField(
                style: const TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 39, 63))),
                validator: (value) {
                  //return error message or
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Please enter only letters';
                  }
                  return null; //null when valid
                },
              ),
              TextFormField(
                style: const TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 39, 63))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Phone number';
                  }
                  if (value.length != 8) {
                    return 'please enter an 8 digit phone number';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter only numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: submit,
                child: Text(
                  widget.customer != null ? 'Update' : 'Create',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
