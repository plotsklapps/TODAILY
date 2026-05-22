import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todaily/modals/menu_modal.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/screens/journaleditor_screen.dart';
import 'package:todaily/services/modal_service.dart';
import 'package:todaily/services/signal_service.dart';
import 'package:todaily/themes/iconlibrary.dart';
import 'package:todaily/widgets/journalentrycard_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 12,
      initialIndex: DateTime.now().month - 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    sJournalEntries.watch(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: List<Widget>.generate(12, (int index) {
            final int month = index + 1;
            final String monthName = DateFormat(
              'MMMM',
            ).format(DateTime(currentYear, month));
            final int count = sJournalEntries.value.where((JournalEntry e) {
              final DateTime date = DateTime.parse(e.dateKey);
              return date.month == month && date.year == currentYear;
            }).length;

            return Tab(
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Text(monthName),
                  if (count > 0)
                    Positioned(
                      right: -14,
                      top: -10,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: Theme.of(
                                context,
                            ).colorScheme.onSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List<Widget>.generate(12, (int monthIndex) {
          final int month = monthIndex + 1;
          final List<JournalEntry> monthEntries = sJournalEntries.value.where((
            JournalEntry e,
          ) {
            final DateTime date = DateTime.parse(e.dateKey);
            return date.month == month && date.year == currentYear;
          }).toList();

          if (monthEntries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('No entries this month.'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Tap '),
                      IconLibrary.iconPlus,
                      const Text(' to write your todaily.'),
                    ],
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: monthEntries.length,
            itemBuilder: (_, int index) {
              // Sort by date descending (most recent first)
              final List<JournalEntry> sortedEntries =
                  List<JournalEntry>.from(
                    monthEntries,
                  )..sort((JournalEntry a, JournalEntry b) {
                    return DateTime.parse(b.dateKey).compareTo(
                      DateTime.parse(a.dateKey),
                    );
                  });

              final JournalEntry entry = sortedEntries[index];

              return JournalEntryCard(entry: entry);
            },
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        child: IconLibrary.iconPlus,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) {
                return JournalEditorScreen(date: DateTime.now());
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                await ModalService.showModal(
                  context: context,
                  child: const MenuModal(),
                  title: 'Menu',
                );
              },
              icon: IconLibrary.iconMenu,
            ),
            Column(
              children: <Widget>[
                Text(
                  'todaily',
                  style: theme.textTheme.displaySmall!.copyWith(fontSize: 26),
                ),
                Text(
                  '2026',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
