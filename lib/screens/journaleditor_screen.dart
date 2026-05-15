import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:todaily/modals/emojipicker_modal.dart';
import 'package:todaily/modals/imagepicker_modal.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/journal_service.dart';
import 'package:todaily/services/modal_service.dart';
import 'package:todaily/themes/iconlibrary.dart';
import 'package:todaily/widgets/charcounter_widget.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({
    required this.date,
    super.key,
  });
  final DateTime date;

  @override
  State<JournalEditorScreen> createState() {
    return _JournalEditorScreenState();
  }
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  late final QuillController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final String dateKey = JournalService.getDateKey(widget.date);
    final JournalEntry? entry = JournalService.readJournal(dateKey);

    if (entry != null) {
      _controller = QuillController(
        document: Document.fromDelta(Delta.fromJson(entry.description)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      sSelectedEmojis.value = List<String>.from(entry.emojis);
    } else {
      _controller = QuillController.basic();
      sSelectedEmojis.value = <String>[];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getOrdinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // We add 80 to account for FAB + some padding
    final double totalBottomInset = keyboardHeight + 80;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          DateFormat(
            "yyyy, MMMM d'${_getOrdinal(widget.date.day)}'",
          ).format(widget.date),
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CharCounterWidget(
              controller: _controller,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                QuillSimpleToolbar(
                  controller: _controller,
                  config: const QuillSimpleToolbarConfig(
                    toolbarSectionSpacing: 0.1,
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions<dynamic, dynamic>(
                        iconSize: 12,
                      ),
                    ),
                    showUndo: false,
                    showRedo: false,
                    showAlignmentButtons: true,
                    showFontFamily: false,
                    showInlineCode: false,
                    showDividers: false,
                    showHeaderStyle: false,
                    showIndent: false,
                    showJustifyAlignment: false,
                    showListCheck: false,
                    showFontSize: false,
                    showColorButton: false,
                    showSuperscript: false,
                    showSubscript: false,
                    showClearFormat: false,
                    showBackgroundColorButton: false,
                    showLink: false,
                    showListBullets: false,
                    showListNumbers: false,
                    showCodeBlock: false,
                    showQuote: false,
                    showStrikeThrough: false,
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: QuillEditor(
                controller: _controller,
                scrollController: _scrollController,
                focusNode: _focusNode,
                config: QuillEditorConfig(
                  // Combination of padding and scrollBottomInset to make
                  // text scroll above FAB instead of behind it.
                  padding: const EdgeInsets.only(bottom: 100),
                  scrollBottomInset: totalBottomInset,
                  placeholder: '...',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'saveFAB',
        onPressed: () async {
          // Hide the keyboard.
          _focusNode.unfocus();

          if (!context.mounted) return;

          // Get dateKey for Hive storage.
          final String dateKey = JournalService.getDateKey(widget.date);

          await ModalService.showModal(
            context: context,
            title: 'Select 1-3 emojis',
            child: EmojiPickerModal(
              onNext: () async {
                // Pop the sheet.
                Navigator.pop(context);

                // Show ImagePickerModal.
                await ModalService.showModal(
                  context: context,
                  title: 'Add up to 6 images',
                  child: ImagePickerModal(
                    initialImages:
                        JournalService.readJournal(dateKey)?.imagePaths ??
                        const <String>[],
                    onSave: (List<String> images) async {
                      // Create/Update a JournalEntry Object.
                      final JournalEntry entry = JournalEntry(
                        dateKey: dateKey,
                        description: _controller.document.toDelta().toJson(),
                        emojis: sSelectedEmojis.value,
                        imagePaths: images,
                      );

                      // Use JournalService to save the entry.
                      final JournalEntry? existing = JournalService.readJournal(
                        dateKey,
                      );
                      if (existing != null) {
                        await JournalService.updateJournal(entry);
                      } else {
                        await JournalService.createJournal(entry);
                      }

                      // Pop all sheets and return to CalendarScreen.
                      if (context.mounted) {
                        Navigator.popUntil(context, (Route<dynamic> route) {
                          return route.isFirst;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
        child: IconLibrary.iconSave,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: IconLibrary.iconBack,
            ),
          ],
        ),
      ),
    );
  }
}
