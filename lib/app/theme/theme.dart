import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_widget/image_picker_widget.dart';

import '../../core/extensions/text_ext.dart';
import '../../core/utils/base_change_notifier.dart';
import '../sizes.dart';
import 'colors.dart';
import 'fonts.dart';

class AppTheme extends BaseChangeNotifier<Brightness> {
  Color contrastColor = AppColors.white;
  Color highlightColor = BlackColor.light;
  Color backgroundColor = BlackColor.medium;

  AppTheme() : super(SchedulerBinding.instance.window.platformBrightness);

  bool get isDark => state == Brightness.dark;

  ThemeData get theme => isDark ? darkTheme : lightTheme;

  void toggleTheme() => state = isDark ? Brightness.light : Brightness.dark;

  void setPlatformTheme() => state = SchedulerBinding.instance.window.platformBrightness;

  late final basetheme = ThemeData(
    primaryColor: AppColors.primary,
    fontFamily: AppFonts.fontFamily,
    colorScheme: AppColors.colors,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(color: BlackColor.light),
    elevatedButtonTheme: elevatedButton,
    inputDecorationTheme: inputField,
    checkboxTheme: const CheckboxThemeData(
      checkColor: MaterialStatePropertyAll(Colors.white),
      fillColor: MaterialStatePropertyAll(AppColors.primary),
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
    dividerTheme: const DividerThemeData(thickness: 1, indent: 5, endIndent: 5, color: BlackColor.light),
    chipTheme: const ChipThemeData(
      labelPadding: EdgeInsets.only(left: 5, right: 5),
      padding: AppPaddings.smallXY,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    navigationBarTheme: navBar,
  );

  late final lightTheme = basetheme.copyWith(
    brightness: Brightness.light,
    textTheme: textThemeLight,
    cardColor: AppColors.highlight,
    scaffoldBackgroundColor: AppColors.scaffoldLight,
    appBarTheme: appBar.copyWith(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      foregroundColor: AppColors.scaffoldDark,
      titleTextStyle: AppFonts.headline6.gray,
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(BlackColor.dark),
      ),
    ),
    inputDecorationTheme: inputField.copyWith(
      fillColor: AppColors.highlight,
      hintStyle: AppFonts.body2.light.copyWith(color: BlackColor.normal, letterSpacing: 0),
    ),
    chipTheme: basetheme.chipTheme.copyWith(
      backgroundColor: AppColors.highlight,
      labelStyle: textThemeLight.bodyLarge!.copyWith(height: 0),
    ),
  );

  late final darkTheme = basetheme.copyWith(
    brightness: Brightness.dark,
    cardColor: BlackColor.medium,
    textTheme: textThemeDark,
    scaffoldBackgroundColor: AppColors.scaffoldDark,
    appBarTheme: appBar.copyWith(
      foregroundColor: AppColors.scaffoldLight,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppFonts.headline6.white.copyWith(height: 0),
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle.copyWith(
        foregroundColor: MaterialStateProperty.all(AppColors.white),
      ),
    ),
    inputDecorationTheme: inputField.copyWith(
      fillColor: BlackColor.medium,
      hintStyle: AppFonts.body2.light.copyWith(
        color: BlackColor.light,
        letterSpacing: 0,
      ),
    ),
    chipTheme: basetheme.chipTheme.copyWith(
      backgroundColor: BlackColor.medium,
      labelStyle: textThemeDark.bodyLarge!.copyWith(height: 0),
    ),
  );

  late final elevatedButton = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      textStyle: MaterialStateProperty.all(AppFonts.body1),
      padding: MaterialStateProperty.all(AppPaddings.normalY),
      foregroundColor: MaterialStateProperty.all(AppColors.white),
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled) //
            ? Colors.black38
            : AppColors.primary,
      ),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );

  late final textButtonStyle = TextButton.styleFrom(
    elevation: 0,
    padding: AppPaddings.largeY,
    textStyle: AppFonts.body1.copyWith(height: 1),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  late final appBar = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
  );

  late final inputField = InputDecorationTheme(
    filled: true,
    errorStyle: AppFonts.body1.copyWith(color: AppColors.colors.error),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: BlackColor.light),
    ),
    contentPadding: AppPaddings.normalXY,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    ),
  );

  final navBar = NavigationBarThemeData(
    iconTheme: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const IconThemeData(color: AppColors.primary)
          : const IconThemeData(color: BlackColor.light),
    ),
    backgroundColor: Colors.transparent,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    labelTextStyle: const MaterialStatePropertyAll(
      TextStyle(color: AppColors.primary, height: 0),
    ),
  );

  late final textThemeDark = TextTheme(
    displayLarge: AppFonts.headline1.white,
    displayMedium: AppFonts.headline2,
    displaySmall: AppFonts.headline3,
    headlineMedium: AppFonts.headline4,
    headlineSmall: AppFonts.headline5,
    titleLarge: AppFonts.headline6.white,
    bodyLarge: AppFonts.body1.white,
    bodyMedium: AppFonts.body2,
    titleMedium: AppFonts.subtitle1,
    titleSmall: AppFonts.subtitle2,
  );

  late final textThemeLight = TextTheme(
    displayLarge: AppFonts.headline1.grayDark,
    displayMedium: AppFonts.headline2.gray,
    displaySmall: AppFonts.headline3.grayDark,
    headlineMedium: AppFonts.headline4.black,
    headlineSmall: AppFonts.headline5.black,
    titleLarge: AppFonts.headline6.gray,
    bodyLarge: AppFonts.body1.gray,
    bodyMedium: AppFonts.body2.gray,
    titleMedium: AppFonts.subtitle1,
    titleSmall: AppFonts.subtitle2.grayDark,
  );

  static final imagePickerModalOptions = ModalOptions(
    title: Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text("Select image from", style: AppFonts.headline5.black),
    ),
    cameraColor: BlackColor.dark,
    galleryColor: BlackColor.dark,
    cameraText: Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Camera", style: AppFonts.body2.black),
    ),
    galleryText: Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Gallery", style: AppFonts.body2.black),
    ),
  );

  @override
  Future<void> init() async {
    updateColors();
    addListener(updateColors);
    return super.init();
  }

  void updateColors() {
    contrastColor = isDark ? AppColors.white : BlackColor.normal;
    highlightColor = isDark ? BlackColor.light : AppColors.highlight;
    backgroundColor = isDark ? BlackColor.medium : AppColors.highlight;

    final invertedBrightness = isDark ? Brightness.light : Brightness.dark;
    final canvasColor = isDark ? BlackColor.dark : Colors.white;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: canvasColor,
        systemNavigationBarColor: canvasColor,
        statusBarIconBrightness: invertedBrightness,
        systemNavigationBarIconBrightness: invertedBrightness,
        statusBarBrightness: invertedBrightness,
      ),
    );
  }
}
