import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class Item {
  final String id;
  String title;
  bool checked;

  Item({
    required this.id,
    required this.title,
    required this.checked,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'checked': checked,
    };
  }
}

class Note extends ChangeNotifier {
  final String id;
  String _title;
  List<Item> _items;

  Note({
    required this.id,
    required String title,
    required List<Item> items,
  })  : _title = title,
        _items = items;

  String get title => _title;
  set title(String value) {
    if (value == _title) return;
    _title = value;
    notifyListeners();
  }

  List<Item> get items => _items;
  List<Item> get sortedItems =>
      _items.toList()..sort((a, b) => a.checked ? 1 : -1);

  void addItem(String title) {
    var titleMatch = title.toLowerCase();
    var match = _items.firstWhereOrNull(
      (item) => item.title.toLowerCase() == titleMatch,
    );
    if (match != null) {
      match.checked = false;
    } else {
      _items.add(Item(
        id: const Uuid().v4(),
        checked: false,
        title: title,
      ));
    }

    notifyListeners();
  }

  void updateItem(Item item, {bool? checked, String? title}) {
    item.checked = checked ?? item.checked;
    item.title = title ?? item.title;
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': _title,
      'items': _items.map((item) => item.toJson()).toList(),
    };
  }
}
