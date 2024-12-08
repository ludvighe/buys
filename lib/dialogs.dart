import 'package:flutter/material.dart';
import 'package:yaru/icons.dart';

void showYesNoModal(
  BuildContext context, {
  required String question,
  void Function()? onYes,
  void Function()? onNo,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(question),
        actions: [
          IconButton(
            icon: const Icon(YaruIcons.checkmark),
            onPressed: () {
              if (onYes != null) onYes();
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(YaruIcons.window_close),
            onPressed: () {
              if (onNo != null) onNo();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
