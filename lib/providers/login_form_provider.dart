import 'package:flutter/material.dart';

class LoginFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isFirstValidationPerformed = false;

  String get email => _email;
  set email(newValue) => _email = newValue;

  String get password => _password;
  set password(newValue) => _password = newValue;

  bool get isLoading => _isLoading;
  set isLoading(newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  bool get isFirstValidationPerformed => _isFirstValidationPerformed;

  bool isValidForm() {
    if (!_isFirstValidationPerformed) _isFirstValidationPerformed = true;

    return formKey.currentState?.validate() ?? false;
  }
}