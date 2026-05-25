import 'package:flutter/material.dart';
import 'package:todaily/widgets/modaltitlerow_widget.dart';

class ModalService {
  static Future<void> showModal({
    required BuildContext context,
    required Widget child,
    required String title,
  }) async {
    await showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return SafeArea(
          minimum: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ModalTitleRow(context: context, title: title),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}
