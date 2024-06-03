import 'package:demohotel/entities/item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MainNotifier extends ChangeNotifier {
  Box? crudBox;
  bool isLoading = true;
  List<Item> items = [];

  MainNotifier() {
    _setCrudBox();
  }

  Future<void> _setCrudBox() async {
    if (!Hive.isBoxOpen("crud")) {
      crudBox = await Hive.openBox("crud");
    } else {
      crudBox = Hive.box("crud");
    }
    _loadItems();
    isLoading = false;
    notifyListeners();
  }

  void _loadItems() {
    items = crudBox!.values
        .map((e) => Item.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    notifyListeners();
  }

  void addItem(String name) {
    final item = Item(id: DateTime.now().toString(), name: name);
    crudBox!.put(item.id, item.toMap());
    items.add(item);
    notifyListeners();
  }

  void updateItem(String id, String name) {
    final item = Item(id: id, name: name);
    crudBox!.put(id, item.toMap());
    final index = items.indexWhere((element) => element.id == id);
    if (index != -1) {
      items[index] = item;
    }
    notifyListeners();
  }

  void deleteItem(String id) {
    crudBox!.delete(id);
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
