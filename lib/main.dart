import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/screens/calendar_screen.dart';
import 'package:todaily/themes/flexscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  await Hive.openBox<JournalEntry>('journals');

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'todaily',
        localizationsDelegates:
            FlutterQuillLocalizations.localizationsDelegates,
        theme: cThemeData.watch(context),
        home: const CalendarScreen(),
      ),
    );
  }
}
