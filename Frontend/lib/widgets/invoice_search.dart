import 'package:ecommerce/models/invoice.dart';
import 'package:ecommerce/widgets/invoice_details.dart';
import 'package:flutter/material.dart';

class InvoiceSearch extends StatefulWidget {
  final List<Invoice> invoices;

  final Function(int)? onDelete;
  final Function(Invoice)? onUpdate;

  const InvoiceSearch(
      {super.key, required this.invoices, this.onDelete, this.onUpdate});

  @override
  State<InvoiceSearch> createState() => _InvoiceSearchState();
}

class _InvoiceSearchState extends State<InvoiceSearch> {
  late List<Invoice> _searchInvoices;

  @override
  void initState() {
    super.initState();
    _searchInvoices = List.from(widget.invoices);
  }

  updateInvoice(Invoice updatedInvoice) {
    setState(() {
      final index = _searchInvoices
          .indexWhere((invoice) => invoice.id == updatedInvoice.id);
      if (index != -1) {
        _searchInvoices[index] = updatedInvoice;
      }
    });

    widget.onUpdate!(updatedInvoice);
  }

  deleteInvoice(int id) {
    setState(() {
      _searchInvoices.removeWhere((invoice) => invoice.id == id);
    });

    widget.onDelete!(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoices',
          style: TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: ListView.builder(
        itemCount: _searchInvoices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchInvoices[index].customer?.name ?? 'no name'),
            textColor: const Color.fromARGB(255, 110, 39, 63),
            titleTextStyle: const TextStyle(fontSize: 25),
            onTap: () async {
              final response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceDetails(
                    invoice: _searchInvoices[index],
                    onUpdate: updateInvoice,
                    onDelete: deleteInvoice,
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
