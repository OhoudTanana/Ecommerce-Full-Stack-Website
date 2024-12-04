import 'package:ecommerce/models/item.dart';
import 'package:ecommerce/widgets/item_details.dart';
import 'package:flutter/material.dart';

class ItemSearch extends StatefulWidget {
  final List<Item> items;

  final Function(Item)? onUpdate;
  final Function(int)? onDelete;

  const ItemSearch(
      {super.key, required this.items, this.onUpdate, this.onDelete});

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  late List<Item> _searchItems;

  @override
  void initState() {
    super.initState();
    _searchItems = widget.items;
  }

  updateItem(Item updatedItem) {
    setState(() {
      final index =
          _searchItems.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        _searchItems[index] = updatedItem;
      }
    });

    widget.onUpdate!(updatedItem);
  }

  deleteItem(int id) {
    setState(() {
      _searchItems.removeWhere((item) => item.id == id);
    });

    widget.onDelete!(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Items',
          style: TextStyle(color: Color.fromARGB(255, 110, 39, 63)),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 110, 39, 63)),
      ),
      body: ListView.builder(
        itemCount: _searchItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchItems[index].name ?? 'no name'),
            textColor: const Color.fromARGB(255, 110, 39, 63),
            titleTextStyle: const TextStyle(fontSize: 25),
            // subtitle: Text(_searchItems[index].description),
            onTap: () async {
              final response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetail(
                    item: _searchItems[index],
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
