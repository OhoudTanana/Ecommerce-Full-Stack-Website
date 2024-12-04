import 'package:ecommerce/models/item.dart';
import 'package:ecommerce/services/item_services.dart';
import 'package:ecommerce/widgets/item_form.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatefulWidget {
  //passed to show the item details
  final Item item;

  //callback functions
  //the parent widget is the once item, once search
  final Function(int)? onDelete;
  final Function(Item)? onUpdate;

  const ItemDetail(
      {super.key, required this.item, this.onDelete, this.onUpdate});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

//actual state of the page, responsible for handling changes in the UI
class _ItemDetailState extends State<ItemDetail> {
  late Item item;
  final ItemService itemService = ItemService();

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  //this updates the item state when its edited
  //setSatet triggers a rebuild of the widget
  updateItem(Item updatedItem) {
    setState(() {
      item = updatedItem;
    });

    //notify the paretn widget of the update
    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.name ?? 'no name',
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
              Text('ID: ${item.id}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Description: ${item.description}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Price: \$${item.price}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 10),
              Text('Stock: ${item.stock}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 110, 39, 63))),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updatedItem = await Navigator.push<Item>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemForm(
                            item: item,
                            onItemUpdated: updateItem,
                          ),
                        ),
                      );

                      if (updatedItem != null) {
                        updateItem(updatedItem);
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
                      await itemService.delete(item.id!);

                      if (widget.onDelete != null) {
                        widget.onDelete!(item.id!);
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
