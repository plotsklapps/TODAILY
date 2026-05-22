extension DayOrdinal on int {
  /// Returns the ordinal suffix for an integer
  /// (e.g. 1 -> "st", 2 -> "nd", 3 -> "rd", 4 -> "th").
  String get ordinalSuffix {
    if (this >= 11 && this <= 13) return 'th';
    switch (this % 10) {
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
}
