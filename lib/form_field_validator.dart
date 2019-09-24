library form_field_validator;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// same function signature as FormTextField's validator;
typedef ValidatorFunction<T> = T Function(T value);

abstract class FormFieldValidatorBase<T> {
  /// the message to display when the validation fails
  final String message;

  /// bypasses empty value if true
  final bool optional;

  FormFieldValidatorBase(this.message, this.optional)
      : assert(message != null),
        assert(optional != null);

  /// returns null if the input is valid otherwise it returns the provided error message
  String validate(T value);

  /// helper function to check if an input matches a given pattern
  bool hasMatch(String pattern, String input) => RegExp(pattern).hasMatch(input);
}

class RequiredValidator extends FormFieldValidatorBase<String> {
  RequiredValidator({@required String message}) : super(message, false);

  @override
  String validate(String value) {
    return value == null || value.isEmpty ? message : null;
  }
}

class MaxLengthValidator extends FormFieldValidatorBase<String> {
  final int max;

  MaxLengthValidator(this.max, {@required String message, bool optional = false}) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      return value.length > max ? message : null;
  }
}

class MinLengthValidator extends FormFieldValidatorBase<String> {
  final int min;

  MinLengthValidator(this.min, {@required String message, bool optional = false}) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      return value.length < min ? message : null;
  }
}

class LengthRangeValidator extends FormFieldValidatorBase<String> {
  final int min;
  final int max;

  LengthRangeValidator(this.min, this.max, {@required String message}) : super(message, false);

  @override
  String validate(String value) {
    return value.length < min || value.length > max ? message : null;
  }
}

class RangeValidator extends FormFieldValidatorBase<String> {
  final num min;
  final num max;

  RangeValidator({@required this.min, @required this.max, @required String message, bool optional = false})
      : super(message, optional);

  @override
  String validate(String value) {
    if (value.isEmpty) {
      return optional ? null : message;
    } else {
      try {
        final numericValue = num.parse(value);
        return (numericValue < min || numericValue > max) ? message : null;
      } catch (_) {
        return message;
      }
    }
  }
}

class EmailValidator extends FormFieldValidatorBase<String> {
  /// regex pattern to validate email inputs.
  final String _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidator({bool optional = false, @required String message}) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      return hasMatch(_emailPattern, value) ? null : message;
  }
}

class PatternValidator extends FormFieldValidatorBase<String> {
  final RegExp regExp;

  PatternValidator(this.regExp, {@required String message, bool optional = false}) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      return regExp.hasMatch(value) ? null : message;
  }
}

class DateValidator extends FormFieldValidatorBase<String> {
  final String format;

  DateValidator(this.format, {@required String message, bool optional = false}) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      try {
        final dateTime = DateFormat(format).parseStrict(value);
        return dateTime != null ? null : message;
      } catch (_) {
        return message;
      }
  }
}

/// passing empty error message to the super construct
/// because every validator should have it's own error message;
const String emptyString = '';

class MultiValidator extends FormFieldValidatorBase {
  final List<FormFieldValidatorBase<String>> validators;
  MultiValidator(this.validators, {bool optional = false}) : super(emptyString, optional);

  @override
  String validate(dynamic value) {
    if (optional && value is String && value.isEmpty)
      return null;
    else
      for (FormFieldValidatorBase validator in validators) {
        final message = validator.validate(value);
        if (message != null) return message;
      }
    return null;
  }
}

/// a special match validator to check if the input equals another provided value;
class MatchValidator {
  final String message;

  MatchValidator({@required this.message});

  String validateMatch(String value, String value2) {
    return value == value2 ? null : message;
  }
}
