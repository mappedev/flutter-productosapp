import 'package:flutter/material.dart';

class LoginFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  set email(newValue) => _email = newValue;

  String get password => _password;
  set password(newValue) => _password = newValue;

  bool get isLoading => _isLoading;
  set isLoading(newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}