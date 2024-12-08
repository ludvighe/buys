import 'package:buys/storage.dart';
import 'package:buys/views/notes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

void main() {
  runApp(const BuysApp());
}

class BuysApp extends StatelessWidget {
  const BuysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buys',
        theme: yaruDark.copyWith(
          colorScheme: yaruDark.colorScheme.copyWith(
            primary: Colors.purple,
          ),
        ),
        home: const NotesView(),
      ),
    );
  }
}
