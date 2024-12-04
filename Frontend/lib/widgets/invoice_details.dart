import 'package:ecommerce/models/invoice.dart';
import 'package:ecommerce/services/invoice_services.dart';
import 'package:ecommerce/widgets/invoice_form.dart';
import 'package:flutter/material.dart';

class InvoiceDetails extends StatefulWidget {
  final Invoice invoice;

  final Function(int)? onDelete;
  final Function(Invoice)? onUpdate;

  const InvoiceDetails(
      {super.key, this.onDelete, this.onUpdate, required this.invoice});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  late Invoice invoice;
  final InvoiceServices invoiceServices = InvoiceServices();

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
  }

  updateInvoice(Invoice updatedInvoice) {
    setState(() {
      invoice = updatedInvoice;
    });

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedInvoice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          invoice.customer!.id.toString(),
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
              Text('Invoice ID: ${invoice.id}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Total Price:${invoice.totalPrice}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Order Date:${invoice.orderDate}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Customer ID:${invoice.customer?.id}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Customer Name:${invoice.customer?.name}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 20),
              const Text('Invoice Items:',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 110, 39, 63),
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap:
                      true, // make the list view take only the needed space
                  itemCount: invoice.invoiceItems?.length,
                  itemBuilder: (context, index) {
                    final invoiceItems = invoice.invoiceItems?[index];
                    return ListTile(
                      title: Text(
                        'Item ID: ${invoiceItems?.item?.id}',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 110, 39, 63)),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        'Quantity: ${invoiceItems?.quantity}\n'
                        'Item Name: ${invoiceItems?.item?.name}\n'
                        'Item Price: ${invoiceItems?.item?.price}',
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
                      final updatedInvoice = await Navigator.push<Invoice>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceForm(
                            invoice: invoice,
                            onUpdate: updateInvoice,
                          ),
                        ),
                      );

                      if (updatedInvoice != null) {
                        updateInvoice(updatedInvoice);
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
                      await invoiceServices.delete(invoice.id!);

                      if (widget.onDelete != null) {
                        widget.onDelete!(invoice.id!);
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
