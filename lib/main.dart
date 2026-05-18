import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:todaily/firebase_options.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/models/settings_model.dart';
import 'package:todaily/screens/calendar_screen.dart';
import 'package:todaily/services/journal_service.dart';
import 'package:todaily/services/settings_service.dart';
import 'package:todaily/themes/flexscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for AI purposes.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive.
  await Hive.initFlutter();

  // Open Hive boxes.
  Hive
    ..registerAdapter(JournalEntryAdapter())
    ..registerAdapter(SettingsAdapter());

  await journalService.init();
  await settingsService.init();

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapper for context-free snackbars.
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
