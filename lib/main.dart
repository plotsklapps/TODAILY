import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:signals/signals_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:todaily/firebase_options.dart';
import 'package:todaily/screens/calendar_screen.dart';
import 'package:todaily/services/service_initializer.dart';
import 'package:todaily/themes/flexscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Boot up all Hive databases, configurations and Gemma.
  await ServiceInitializer.init();

  runApp(const MainEntry());
}

class MainEntry extends StatelessWidget {
  const MainEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapper for context-free toast notifications.
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
