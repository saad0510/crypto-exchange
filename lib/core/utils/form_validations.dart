import '../../app/constants.dart';

class FormValidations {
  static final emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

  static String? name(String? text) {
    if (text == null) return null;
    return text.trim().length >= 3 ? null : AppConstants.nameError;
  }

  static String? iban(String? text) {
    if (text == null) return null;
    return text.trim().length >= 30 ? null : 'Incorrect IBAN';
  }

  static String? email(String? text) {
    if (text == null) return null;
    return emailRegex.hasMatch(text) ? null : AppConstants.emailError;
  }

  static String? password(String? text) {
    if (text == null) return null;
    return text.length >= 6 ? null : AppConstants.passError;
  }

  static String? phone(String? text) {
    if (text == null) return null;
    return text.trim().length >= 4 ? null : AppConstants.phoneError;
  }

  static String? price(String? text) {
    if (text == null) return null;
    double? price = double.tryParse(text.trim());
    if (price == null) return AppConstants.priceError;
    return price > 0 ? null : AppConstants.priceError;
  }

  static String? number(String? text) {
    if (text == null) return null;
    int? number = int.tryParse(text.trim());
    if (number == null) return AppConstants.numberError;
    return number > 0 ? null : AppConstants.numberError;
  }
}
