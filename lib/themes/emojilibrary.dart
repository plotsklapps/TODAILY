import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';

final Signal<List<String>> sAvailableEmojis = Signal<List<String>>(
  kEmojiMap.keys.toList(),
  debugLabel: 'sAvailableEmojis',
);

Widget getEmojiWidget(String key) {
  return HugeIcon(
    icon: kEmojiMap[key]!,
    size: 30,
  );
}

final Map<String, List<List<dynamic>>> kEmojiMap =
    <String, List<List<dynamic>>>{
      'Angel': HugeIcons.strokeRoundedAngel,
      'StarFace': HugeIcons.strokeRoundedStarFace,
      'Happy': HugeIcons.strokeRoundedHappy,
      'Happy01': HugeIcons.strokeRoundedHappy01,
      'Smile': HugeIcons.strokeRoundedSmile,
      'Wink': HugeIcons.strokeRoundedWink,
      'Laughing': HugeIcons.strokeRoundedLaughing,
      'Tongue02': HugeIcons.strokeRoundedTongue01,
      'InLove': HugeIcons.strokeRoundedInLove,
      'Kissing': HugeIcons.strokeRoundedKissing,
      'Evil': HugeIcons.strokeRoundedEvil,
      'Angry': HugeIcons.strokeRoundedAngry,
      'Grinning': HugeIcons.strokeRoundedGrinning,
      'Surprise': HugeIcons.strokeRoundedSurprise,
      'Sad01': HugeIcons.strokeRoundedSad01,
      'Displeased': HugeIcons.strokeRoundedDispleased,
      'Meh': HugeIcons.strokeRoundedMeh,
      'Pensive': HugeIcons.strokeRoundedPensive,
      'Worry': HugeIcons.strokeRoundedWorry,
      'Crying': HugeIcons.strokeRoundedCrying,
      'Crazy': HugeIcons.strokeRoundedCrazy,
      'Vomiting': HugeIcons.strokeRoundedVomiting,
      'Drooling': HugeIcons.strokeRoundedDrooling,
      'Kid': HugeIcons.strokeRoundedKid,
      'MedicalMask': HugeIcons.strokeRoundedMedicalMask,
      'Dead': HugeIcons.strokeRoundedDead,
      'Shocked': HugeIcons.strokeRoundedShocked,
      'Mute': HugeIcons.strokeRoundedMute,
      'Sleeping': HugeIcons.strokeRoundedSleeping,
      'Sunglasses': HugeIcons.strokeRoundedSunglasses,
    };
