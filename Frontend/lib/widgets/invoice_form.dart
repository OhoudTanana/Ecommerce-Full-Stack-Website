import 'package:ecommerce/models/customer.dart';
import 'package:ecommerce/models/invoice.dart';
import 'package:ecommerce/models/invoice_items.dart';
import 'package:ecommerce/models/item.dart';
import 'package:ecommerce/services/customer_services.dart';
import 'package:ecommerce/services/invoice_services.dart';
import 'package:ecommerce/services/item_services.dart';
import 'package:flutter/material.dart';

class InvoiceForm extends StatefulWidget {
  final Invoice? invoice;
  final Function(Invoice)? onUpdate;
  final Function(Invoice)? onCreate;

  const InvoiceForm({super.key, this.invoice, this.onUpdate, this.onCreate});

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final _formKey = GlobalKey<FormState>();
  final InvoiceServices invoiceServices = InvoiceServices();
  final ItemService itemService = ItemService();
  final CustomerService customerService = CustomerService();

  late TextEditingController _idController;

  late List<TextEditingController>
      _quantityController; //for handling quantities for each item in invoice

  Map<int, int> itemStock =
      {}; //map that keeps track of availabe stock for each item
  double totalPrice = 0.0; //totalPrice of invoice

  late List<Customer?> customers = []; //list of all available customers
  Customer?
      _selectedCustomer; //holds the currently selected customer in dropdown

  late List<Item?> items = [];
  late List<Item?> _selectedItems; // Store selected items

  @override
  void initState() {
    //initialize the state of the widget
    super.initState();
    _idController = TextEditingController(
        text: widget.invoice?.id.toString() ??
            ''); //sets the ID of invoice if editing else its empty

    if (widget.invoice != null) {
      //if editing
      _selectedItems = widget.invoice!.invoiceItems!.map((invoiceItem) {
        return invoiceItem.item; // Initialize with existing items
      }).toList();
      _quantityController = widget.invoice!.invoiceItems!.map((invoiceItem) {
        return TextEditingController(
            text: invoiceItem.quantity?.toString() ??
                ''); //initialize based on existing invoice data
      }).toList();
    } else {
      _selectedItems = [null]; // Use an empty item if creating a new invoice
      _quantityController = [
        TextEditingController()
      ]; // Initialize with one empty controller
    }

    //fetch from backend
    _fetchCustomers();
    _fetchItems();
    _fetchStock();
  }

  // Reset totalPrice to avoid accumulating on multiple calls
  //iterates through the selected items and their quantities, calculates total price and creates InvoiceItems objects
  Future<List<InvoiceItems>> getInvoiceItems() async {
    totalPrice = 0.0;
    List<InvoiceItems> invoiceItems = [];
    for (int i = 0; i < _selectedItems.length; i++) {
      final quantity = int.tryParse(_quantityController[i].text);
      if (_selectedItems[i] != null && quantity != null && quantity > 0) {
        final item = _selectedItems[i]!;
        totalPrice += (item.price! * quantity);
        invoiceItems.add(InvoiceItems(item: item, quantity: quantity));
      }
    }
    return invoiceItems;
  }

  // Fetch available stock for selected items
  Future<void> _fetchStock() async {
    final stockMap = <int, int>{};
    for (var item in _selectedItems) {
      if (item != null) {
        stockMap[item.id!] = item.stock ?? 0; // Assuming item.id is non-null
      }
    }
    setState(() {
      itemStock = stockMap;
    });
  }

  //fetch the list of customers and update the state, if editing it sets the selected customer
  Future<void> _fetchCustomers() async {
    final response = await customerService.get();
    setState(() {
      customers = response;

      // Set selected customer if editing an invoice after customers are fetched
      if (widget.invoice?.customer != null) {
        _selectedCustomer = customers.firstWhere(
            (customer) => customer?.id == widget.invoice!.customer!.id);
      }
    });
  }

  //fetch the list of customers and update the state, if editing it sets the selected customer
  Future<void> _fetchItems() async {
    final response = await itemService.getAll();
    setState(() {
      items = response;

      // Ensure selected items are properly initialized when editing
      if (widget.invoice != null) {
        _selectedItems = widget.invoice!.invoiceItems!.map((invoiceItem) {
          return items.firstWhere((item) => item?.id == invoiceItem.item!.id);
        }).toList();

        // Fetch stock after setting selected items
        _fetchStock();
      }
    });
  }

  //validate the form and create create or update based on if invoice ID exists or no
  submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final invoiceItems = await getInvoiceItems();
      final invoice = Invoice(
        id: int.tryParse(_idController.text),
        customer: _selectedCustomer,
        invoiceItems: invoiceItems,
        totalPrice: totalPrice,
        orderDate: DateTime.now(),
      );

      // Check if updating or creating a new invoice
      if (invoice.id != null) {
        await invoiceServices.patch(invoice, invoice.id!);
        widget.onUpdate!(invoice);
      } else {
        Invoice createdInvoice = await invoiceServices.create(invoice);
        widget.onCreate!(createdInvoice);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, createdInvoice);
        return;
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      // ignore: avoid_print
      print('Validation failed');
    }
  }

  //cleans up the memory when disposed
  @override
  void dispose() {
    _idController.dispose();
    for (var controller in _quantityController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.invoice != null ? 'Edit Invoice' : 'New Invoice',
            style: const TextStyle(color: Color.fromARGB(255, 110, 39, 63))),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.invoice != null)
                  TextFormField(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 110, 39, 63)),
                    controller: _idController,
                    decoration: const InputDecoration(
                        labelText: 'ID',
                        labelStyle: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 110, 39, 63))),
                    enabled: false,
                  ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Customer>(
                  //combines a dropdown button with form field functionality
                  decoration: const InputDecoration(
                    labelText: 'Select Customer',
                    labelStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 39, 63)),
                  ),
                  value:
                      _selectedCustomer, //holds the customer object that is currently chosen by the user
                  items: customers.map((Customer? customer) {
                    //this maps over customers list and create a list of dropdown menu items from them
                    return DropdownMenuItem<Customer>(
                      value:
                          customer, //this will be returned when the user selects the corresponding item
                      child: Text('${customer?.id} - ${customer?.name}',
                          style: const TextStyle(
                              color: Color.fromARGB(
                                  255, 110, 39, 63))), // Show ID and name
                    );
                  }).toList(),
                  onChanged: (Customer? newValue) {
                    //this is triggered when the user chooses another customer
                    setState(() {
                      _selectedCustomer =
                          newValue; //customer is updated, this ensures that UI reflects the change
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a customer'
                      : null, //this is  avalidator
                ),
                const SizedBox(height: 20),
                const Text('Invoice Items',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 39, 63))),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedItems.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Item>(
                              decoration: const InputDecoration(
                                labelText: 'Select Item',
                                labelStyle: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 110, 39, 63)),
                              ),
                              value: (_selectedItems[index] != null &&
                                      items.contains(_selectedItems[index]))
                                  ? _selectedItems[index]
                                  : null, //each item in invoice has its own dropdown list, each dropdown corresponds to one index in _selectedItems
                              items: items.map((Item? item) {
                                return DropdownMenuItem<Item>(
                                  value: item,
                                  child: Text('${item?.id} - ${item?.name}',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 110, 39,
                                              63))), // Show ID and name
                                );
                              }).toList(),
                              //when i choose an item, this is triggered
                              onChanged: (Item? newValue) {
                                setState(() {
                                  _selectedItems[index] = newValue;
                                });

                                //fetching stock after choosign the item
                                _fetchStock();
                              },
                              validator: (value) => value == null
                                  ? 'Please select an item'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 110, 39, 63)),
                              controller: _quantityController[index],
                              decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 110, 39, 63))),
                              //validating wuantity
                              validator: (value) {
                                final newQuantity = int.tryParse(value ?? '');
                                if (newQuantity == null || newQuantity <= 0) {
                                  return 'Please enter a positive quantity';
                                }
                                if (_selectedItems[index] != null) {
                                  final item = _selectedItems[index]!;
                                  final stock =
                                      itemStock[_selectedItems[index]!.id!] ??
                                          0; // Get stock for selected item

                                  final existingInvoiceItem =
                                      //this accesses the invoiceItems list from the invoice object
                                      //firstWhere, brings the first item that its id matches the item id being validated
                                      widget.invoice?.invoiceItems?.firstWhere(
                                          (invoiceItem) =>
                                              invoiceItem.item?.id == item.id,
                                          orElse: () => InvoiceItems(
                                              quantity: 0, item: item));

                                  final existingQuantity =
                                      existingInvoiceItem?.quantity ?? 0;

                                  if (newQuantity >
                                      (stock + existingQuantity)) {
                                    return 'Quantity exceeds available stock';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'Remove Item',
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Color.fromARGB(255, 110, 39, 63)),
                              onPressed: () {
                                setState(() {
                                  _selectedItems.removeAt(index);
                                  _quantityController.removeAt(index);
                                  _fetchStock();
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedItems.add(null); // Add empty item
                          _quantityController.add(TextEditingController());
                        });
                      },
                      child: const Text('Add Item'),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: submit,
                      child: Text(
                        widget.invoice != null
                            ? 'Update Invoice'
                            : 'Create Invoice',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
