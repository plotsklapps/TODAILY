import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/models/journal_entry.dart';
import 'package:todaily/services/ai_service.dart';
import 'package:todaily/themes/emojilibrary.dart';

export 'package:signals/signals_flutter.dart';

// ==========================================
// 1. Theme & Screen Preferences
// ==========================================
final Signal<FlexScheme> sFlexScheme = Signal<FlexScheme>(
  FlexScheme.shark,
  debugLabel: 'sFlexScheme',
);

final Signal<bool> sDarkMode = Signal<bool>(
  false,
  debugLabel: 'sDarkMode',
);

final Signal<bool> sWakelock = Signal<bool>(
  true,
  debugLabel: 'sWakelock',
);

final Signal<String> sFont = Signal<String>(
  'Questrial',
  debugLabel: 'sFont',
);

// ==========================================
// 2. AI Settings & Download State
// ==========================================
final Signal<AIProvider> sAIProvider = Signal<AIProvider>(
  AIProvider.geminiApi,
  debugLabel: 'sAIProvider',
);

final Signal<bool> sIsDownloading = Signal<bool>(
  false,
  debugLabel: 'sIsDownloading',
);

final Signal<int> sDownloadProgress = Signal<int>(
  0,
  debugLabel: 'sDownloadProgress',
);

// ==========================================
// 3. Editor Preferences & Selection State
// ==========================================
final Signal<int> sMaxCharacters = Signal<int>(
  0,
  debugLabel: 'sMaxCharacters',
);

final Signal<List<String>> sSelectedEmojis = Signal<List<String>>(
  <String>[],
  debugLabel: 'sSelectedEmojis',
);

final Signal<List<String>> sAvailableEmojis = Signal<List<String>>(
  kEmojiMap.keys.toList(),
  debugLabel: 'sAvailableEmojis',
);

final Signal<List<String>> sSelectedImages = Signal<List<String>>(
  <String>[],
  debugLabel: 'sSelectedImages',
);

// ==========================================
// 4. Utility / Library Configurations
// ==========================================
final Signal<List<String>> sStopwords = Signal<List<String>>(
  <String>[
    'a', 'about', 'above', 'after', 'again', 'against', 'all', 'am', 'an',
    'and', 'any', 'are', 'as', 'at', 'be', 'because', 'been', 'before',
    'being', 'below', 'between', 'both', 'but', 'by', 'could', 'did', 'do',
    'does', 'doing', 'down', 'during', 'each', 'few', 'for', 'from',
    'further', 'had', 'has', 'have', 'having', 'he', 'her', 'here', 'hers',
    'herself', 'him', 'himself', 'his', 'how', 'i', 'if', 'in', 'into',
    'is', 'it', 'its', 'itself', 'just', 'me', 'more', 'most', 'my',
    'myself', 'no', 'nor', 'not', 'now', 'of', 'off', 'on', 'once', 'only',
    'or', 'other', 'our', 'ours', 'ourselves', 'out', 'over', 'own', 'she',
    'should', 'so', 'some', 'such', 'than', 'that', 'the', 'their',
    'theirs', 'them', 'themselves', 'then', 'there', 'these', 'they',
    'this', 'those', 'through', 'to', 'too', 'under', 'until', 'up',
    'very', 'was', 'we', 'were', 'what', 'when', 'where', 'which', 'while',
    'who', 'whom', 'why', 'will', 'with', 'you', 'your', 'yours',
    'yourself', 'yourselves', 'get', 'got', 'said', 'went', 'day', 'today',
    'really', 'think', 'thought', 'like',
  ],
  debugLabel: 'sStopwords',
);

// ==========================================
// 5. Database Records & Persistent Collections
// ==========================================
final Signal<List<JournalEntry>> sJournalEntries = Signal<List<JournalEntry>>(
  <JournalEntry>[],
  debugLabel: 'sJournalEntries',
);
