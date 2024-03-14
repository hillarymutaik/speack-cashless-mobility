import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

const bool isDark = false;
const String baseUrl = 'https://ntsa.gopay.ke/api/v1';
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
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ],
);

final username = MultiValidator([
  RequiredValidator(errorText: 'Username required'),
  MinLengthValidator(5, errorText: 'E.g joseph'),
  MaxLengthValidator(10, errorText: 'Enter a valid username'),
]);

final regNoValidator = MultiValidator([
  RequiredValidator(errorText: 'Registration number required'),
  MinLengthValidator(7, errorText: 'E.g Kxx123x, KMxx123x'),
  MaxLengthValidator(8, errorText: 'Enter a valid registration number'),
]);

String? amountValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Amount required';
  }

  if (double.tryParse(value) == null) {
    return 'Enter a valid number';
  }

  if (double.parse(value) < 1) {
    return 'Minimum amount is KSH450.00';
  }

  return null; // Validation passed
}

// final amountValidator = MultiValidator([
//   RequiredValidator(errorText: 'Amount required'),
//   CustomValidator((value) {
//     if (value == null || value.isEmpty) {
//       return null; // Allow empty values as it's already covered by RequiredValidator
//     }
//
//     if (double.tryParse(value) == null) {
//       return 'Enter a valid number'; // Check if the value is a valid number
//     }
//
//     if (double.parse(value) < 450) {
//       return 'Minimum amount is Ksh450';
//     }
//
//     return null; // Validation passed
//   }),
//   MaxLengthValidator(5, errorText: 'Enter a valid amount'),
// ]);