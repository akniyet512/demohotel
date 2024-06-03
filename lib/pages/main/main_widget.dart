import 'package:demohotel/entities/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_notifier.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainNotifier(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    MainNotifier notifier = context.watch<MainNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD Example'),
      ),
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notifier.items.length,
              itemBuilder: (context, index) {
                final item = notifier.items[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showEditDialog(context, item, notifier),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          notifier.deleteItem(item.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context, notifier),
      ),
    );
  }

  void _showAddDialog(BuildContext context, MainNotifier notifier) {
    final _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Item Name'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              notifier.addItem(_nameController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Item item, MainNotifier notifier) {
    final _nameController = TextEditingController(text: item.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Item Name'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () {
              notifier.updateItem(item.id, _nameController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
