extension DateStrExt on DateTime {
  String get numericDate => '$day/$month/$year';

  String get ageStr {
    final days = DateTime.now().difference(this).inDays;
    if (days == 0) return timeFormated;
    return "$day-$month-$year";
  }

  String get datetimeFormated {
    final days = difference(DateTime.now()).inDays;
    if (days == 0) return timeFormated;
    return '$timeFormated, $day-$month-$year';
  }

  String get timeFormated {
    final hr = hour.toString().padLeft(2, '0');
    final min = minute.toString().padLeft(2, '0');
    return '$hr:$min';
  }
}

String getMonthStr(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'None';
  }
}
