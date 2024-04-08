import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const bool isDark = false;
const String baseUrl = 'http://52.23.50.252:9077/api';
const Color backgroundColor = Colors.white;

final phoneValidator = MultiValidator([
  RequiredValidator(errorText: 'M-PESA number required'),
  MinLengthValidator(10, errorText: 'Format 07xxxxxxxx'),
  MaxLengthValidator(10, errorText: 'Enter a valid M-PESA number'),
]);
final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email required'),
  PatternValidator(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      errorText: 'Incorrect email address')
]);

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Password required'),
    MinLengthValidator(8,
        errorText: 'Password must be at least 8 characters long'),
  ],
);

final pinValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'PIN required'),
    MinLengthValidator(4, errorText: 'PIN must be at least 4 characters long'),
  ],
);
final name = MultiValidator([
  RequiredValidator(errorText: 'Name required'),
  MinLengthValidator(5, errorText: 'E.g joseph'),
  MaxLengthValidator(10, errorText: 'Enter a valid name'),
]);
String? amountValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Amount required';
  }

  if (double.tryParse(value) == null) {
    return 'Enter a valid number';
  }

  if (double.parse(value) < 1) {
    return 'Minimum amount is KSH10.00';
  }

  return null; // Validation passed
}
