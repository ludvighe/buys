import 'package:buys/consts.dart';
import 'package:buys/dialogs.dart';
import 'package:buys/models.dart';
import 'package:buys/storage.dart';
import 'package:buys/views/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/yaru.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesStore>(context, listen: false).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Buys'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<NotesStore>().createNote(),
        child: const Icon(YaruIcons.plus),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        children: context
            .watch<NotesStore>()
            .notes
            .map(
              (note) => ChangeNotifierProvider.value(
                value: note,
                child: notesCard(context),
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget notesCard(BuildContext context) {
  return Consumer<Note>(
    builder: (context, note, _) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider.value(
                value: note,
                child: const NoteView(),
              );
            }),
          ),
          onLongPress: () => showYesNoModal(
            context,
            question: 'Confirm deletion of: "${note.title}"',
            onYes: () => context.read<NotesStore>().removeNote(note),
          ),
          child: Padding(
            padding: edgeInsetsVertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${note.items.where((i) => !i.checked).length} / ${note.items.length}',
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
