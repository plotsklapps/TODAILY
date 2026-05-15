import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import 'package:todaily/modals/emojipicker_modal.dart';
import 'package:todaily/modals/imagepicker_modal.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/ai_service.dart';
import 'package:todaily/services/format_service.dart';
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
  late final String _dateKey;
  late final QuillController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Fetch dateKey (yyyyMMdd) for use throughout file.
    _dateKey = JournalService.getDateKey(widget.date);

    // Fetch possibly existing Journal.
    final JournalEntry? entry = JournalService.readJournal(_dateKey);

    if (entry != null) {
      // Fetch previously entered Journal.
      _controller = QuillController(
        document: Document.fromDelta(Delta.fromJson(entry.description)),
        selection: const TextSelection.collapsed(offset: 0),
      );

      // Fetch previously entered emoji's/images.
      sSelectedEmojis.value = List<String>.from(entry.emojis);
      sSelectedImages.value = List<String>.from(entry.imagePaths);
    } else {
      // Show empty textfield.
      _controller = QuillController.basic();

      // Create empty Signals for emoji's/images.
      sSelectedEmojis.value = <String>[];
      sSelectedImages.value = <String>[];
    }

    // Show cursor directly after initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Kill all controllers.
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Dynamically calculate space needed at bottom to make text scroll
    // above saveFAB instead of behind it.
    const double bottomBarHeight = 80;
    const double fabOverlap = 32;

    final double dynamicPadding = safeAreaBottom + bottomBarHeight + fabOverlap;
    final double totalBottomInset =
        keyboardHeight + safeAreaBottom + bottomBarHeight;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          DateFormat(
            "yyyy, MMMM d'${FormatService.getOrdinal(widget.date.day)}'",
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
                  padding: EdgeInsets.only(bottom: dynamicPadding),
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
                    initialImages: sSelectedImages.value,
                    onSave: (List<String> images) async {
                      // Create/Update a JournalEntry Object without an AI title initially.
                      final JournalEntry entry = JournalEntry(
                        dateKey: _dateKey,
                        description: _controller.document.toDelta().toJson(),
                        emojis: sSelectedEmojis.value,
                        imagePaths: images,
                        aiTitle:
                            null, // Title is null, signaling it's being generated.
                      );

                      // Use JournalService to save the entry.
                      final JournalEntry? existing = JournalService.readJournal(
                        _dateKey,
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

                      // Trigger background AI title generation.
                      try {
                        final String journalText = _controller.document
                            .toPlainText();
                        final String generatedTitle =
                            await AIService.generateTitle(journalText);

                        // Update the entry with the generated title.
                        final JournalEntry updatedEntry = JournalEntry(
                          dateKey: _dateKey,
                          description: entry.description,
                          emojis: entry.emojis,
                          imagePaths: entry.imagePaths,
                          aiTitle: generatedTitle,
                        );
                        await JournalService.updateJournal(updatedEntry);
                      } catch (e) {
                        final JournalEntry fallbackEntry = JournalEntry(
                          dateKey: _dateKey,
                          description: entry.description,
                          emojis: entry.emojis,
                          imagePaths: entry.imagePaths,
                          aiTitle: 'My Todaily', // Fallback
                        );
                        await JournalService.updateJournal(fallbackEntry);
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
