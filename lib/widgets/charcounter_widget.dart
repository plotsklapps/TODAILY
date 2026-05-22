import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:todaily/services/modal_service.dart';
import 'package:todaily/services/signal_service.dart';

class CharCounterWidget extends StatelessWidget {
  const CharCounterWidget({
    required this.controller,
    super.key,
  });

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    final int maxCharacters = sMaxCharacters.watch(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final int charCount = controller.document.length;
        final int displayCount = charCount > 0 ? charCount - 1 : 0;

        // Apply limit only if it's not infinite (represented by 0 or less)
        if (maxCharacters > 0 && displayCount > maxCharacters) {
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

        return InkWell(
          onTap: () => _showCharLimitModal(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              maxCharacters > 0
                  ? '$displayCount / $maxCharacters'
                  : '$displayCount / ∞',
              style: TextStyle(
                color: maxCharacters > 0 && displayCount > maxCharacters
                    ? Colors.red
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCharLimitModal(BuildContext context) async {
    const List<int> limits = <int>[500, 1000, 1500, 2000, 0];
    final int currentLimit = sMaxCharacters.watch(context);
    await ModalService.showModal(
      context: context,
      title: 'Character Limit',
      child: SegmentedButton<int>(
        selected: <int>{currentLimit},
        onSelectionChanged: (Set<int> newSelection) {
          sMaxCharacters.value = newSelection.first;
          Navigator.pop(context);
        },
        showSelectedIcon: false,
        segments: limits.map((int limit) {
          return ButtonSegment<int>(
            value: limit,
            label: limit > 0
                ? Text('$limit')
                : const HugeIcon(
                    icon: HugeIcons.strokeRoundedInfinityCircle,
                    size: 20,
                  ),
          );
        }).toList(),
      ),
    );
  }
}
