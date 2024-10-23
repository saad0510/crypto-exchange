String formatInPrice(double? x, [int roundTo = 5]) {
  double price = x ?? 0;
  var values = price.toStringAsFixed(roundTo).split('');
  int i = values.indexOf('.');
  while (i > 3) {
    i -= 3;
    values.insert(i, ',');
  }

  i = values.length - 1;
  int end = values.indexOf('.');
  while (i >= end) {
    if (values[i] != '0') break;
    values.removeLast();
    i--;
  }
  if (values.last == '.') values.removeLast();
  return values.join();
}

String formatInBillions(double? x) {
  x ??= 0;
  final val = x ~/ 100000000;
  final remainder = val % 10;
  final bils = val ~/ 10;
  return '$bils.${remainder}B';
}

String formatInMillions(double? x) {
  x ??= 0;
  final val = x ~/ 100000;
  final remainder = val % 10;
  final bils = val ~/ 10;
  return '$bils.${remainder}M';
}
