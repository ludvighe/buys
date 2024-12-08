import 'package:buys/consts.dart';
import 'package:buys/models.dart';
import 'package:buys/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;
  late TextEditingController _addController;
  late FocusNode _addFocusNode;

  @override
  void initState() {
    super.initState();
    final Note note = context.read<Note>();

    _titleController = TextEditingController(text: note.title);
    _titleFocusNode = FocusNode();
    _titleController.addListener(() {
      if (note.title == _titleController.text) return;
      note.title = _titleController.text;
      context.read<NotesStore>().store();
    });

    _addController = TextEditingController();
    _addFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Note>(
      builder: (context, note, _) {
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 36.0),
              TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  autofocus: note.title == '',
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    contentPadding: edgeInsets,
                  ),
                  style: const TextStyle(color: YaruColors.warmGrey)),
              Expanded(
                child: ListView.builder(
                  itemCount: note.items.length,
                  itemBuilder: (context, idx) {
                    var item = note.sortedItems[idx];
                    return Container(
                      color: idx % 2 == 0 ? null : YaruColors.coolGrey,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onLongPress: () {
                          _addController.text = item.title;
                          note.removeItem(item);
                          _addFocusNode.requestFocus();
                          context.read<NotesStore>().store();
                        },
                        dense: true,
                        title: Padding(
                          padding: edgeInsets,
                          child: Text(item.title),
                        ),
                        trailing: Checkbox(
                          value: item.checked,
                          onChanged: (checked) {
                            note.updateItem(item, checked: checked);
                            context.read<NotesStore>().store();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: _addController,
                focusNode: _addFocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addController.clear();
                      _addFocusNode.unfocus();
                    },
                    icon: const Icon(YaruIcons.edit_clear),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    note.addItem(value);
                    _addController.clear();
                    context.read<NotesStore>().store();
                  }

                  _addFocusNode.requestFocus();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
