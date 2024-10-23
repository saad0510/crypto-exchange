import 'package:flutter/cupertino.dart';

class AppSizes {
  static const smallX = SizedBox(width: 8);
  static const normalX = SizedBox(width: 15);

  static const smallY = SizedBox(height: 8);
  static const normalY = SizedBox(height: 15);
  static const largeY = SizedBox(height: 20);
  static const maxY = SizedBox(height: 30);
}

class AppPaddings {
  static const zero = EdgeInsets.zero;
  static const smallX = EdgeInsets.symmetric(horizontal: 8);
  static const normalX = EdgeInsets.symmetric(horizontal: 15);

  static const normal = EdgeInsets.symmetric(vertical: 15, horizontal: 15);

  static const smallY = EdgeInsets.symmetric(vertical: 8);
  static const normalY = EdgeInsets.symmetric(vertical: 15);
  static const largeY = EdgeInsets.symmetric(vertical: 20);
  static const maxY = EdgeInsets.symmetric(vertical: 30);

  static const smallXY = EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  static const normalXY = EdgeInsets.symmetric(vertical: 15, horizontal: 20);
}
