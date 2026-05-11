import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CharCounterWidget extends StatelessWidget {
  const CharCounterWidget({
    required this.controller,
    required this.maxCharacters,
    super.key,
  });

  final QuillController controller;
  final int maxCharacters;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final int charCount = controller.document.length;
        final int displayCount = charCount > 0 ? charCount - 1 : 0;

        // Forceer limiet indien overschreden
        if (displayCount > maxCharacters) {
          unawaited(
            Future<void>.microtask(() {
              final int excess = displayCount - maxCharacters;
              controller.replaceText(
                controller.document.length - 1 - excess,
                excess,
                '',
                TextSelection.collapsed(
                  offset: controller.document.length - 1 - excess,
                ),
              );
            }),
          );
        }

        return Text(
          '$displayCount / $maxCharacters',
          style: TextStyle(
            color: displayCount > maxCharacters ? Colors.red : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
