import 'dart:convert';

import 'package:buys/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class NotesStore extends ChangeNotifier {
  static String key = 'notes-store';
  List<Note> notes = [];
  DateTime lastStoredAt = DateTime.now();

  Future<void> load() async {
    var prefs = await SharedPreferences.getInstance();
    var serialized = prefs.getString(NotesStore.key);
    if (serialized == null) {
      await store();
      return;
    }

    var json = jsonDecode(serialized);
    notes = (json['notes'] as List<dynamic>)
        .map((note) => Note.fromJson(note))
        .toList();
    lastStoredAt = DateTime.parse(json['lastStoredAt']);

    notifyListeners();
  }

  Future<void> store() async {
    var prefs = await SharedPreferences.getInstance();
    lastStoredAt = DateTime.now();
    Map<String, dynamic> json = {
      'lastStoredAt': lastStoredAt.toString(),
      'notes': notes.map((note) => note.toJson()).toList(),
    };
    prefs.setString(NotesStore.key, jsonEncode(json));
    notifyListeners();
  }

  Future<Note> createNote({String title = 'Untitled'}) async {
    var note = Note(
      id: const Uuid().v4(),
      title: title,
      items: [],
    );
    notes.add(note);
    store();
    notifyListeners();
    return note;
  }

  Future<void> removeNote(Note note) async {
    notes.remove(note);
    store();
    notifyListeners();
  }
}
