import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/modals/emojipicker_modal.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/modal_service.dart';
import 'package:todaily/widgets/char_counter_widget.dart';

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

  @override
  void initState() {
    super.initState();
    final Box<JournalEntry> box = Hive.box<JournalEntry>('journals');
    final String dateKey = _getDateKey(widget.date);

    if (box.containsKey(dateKey)) {
      final JournalEntry entry = box.get(dateKey)!;
      _controller = QuillController(
        document: Document.fromDelta(Delta.fromJson(entry.description)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      sSelectedEmojis.value = List<String>.from(entry.emojis);
    } else {
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getDateKey(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
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
    final List<String> selectedEmojis = sSelectedEmojis.watch(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat(
                      "yyyy, MMMM d'${_getOrdinal(widget.date.day)}'",
                    ).format(widget.date),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  CharCounterWidget(
                    maxCharacters: 500,
                    controller: _controller,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                child: QuillEditor.basic(
                  controller: _controller,
                  config: const QuillEditorConfig(
                    placeholder: 'Write your story here...',
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'emojiFAB',
            onPressed: () async {
              await ModalService.showModal(
                context: context,
                child: const EmojiPickerModal(),
                title: 'Emoji Picker',
              );
            },
            child: const Icon(LucideIcons.smile),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'saveFAB',
            onPressed: () async {
              if (selectedEmojis.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select at least one emoji'),
                  ),
                );
                return;
              }
              final Box<JournalEntry> box = Hive.box<JournalEntry>('journals');
              final String dateKey = _getDateKey(widget.date);

              final JournalEntry entry = JournalEntry(
                dateKey: dateKey,
                description: _controller.document.toDelta().toJson(),
                emojis: selectedEmojis,
              );
              await box.put(dateKey, entry);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.save_outlined),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'imageFAB',
            onPressed: () {},
            child: const Icon(LucideIcons.image),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
