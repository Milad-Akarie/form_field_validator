library form_field_validator;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// same function signature as FormTextField's validator;
typedef ValidatorFunction<T> = T Function(T value);

abstract class FieldValidator<T> {
  /// the errorText to display when the validation fails
  final String errorText;

  FieldValidator(this.errorText) : assert(errorText != null);

  /// checks the input against the given conditions
  bool isValid(T value);

  /// call is a special function that makes a class callable
  /// returns null if the input is valid otherwise it returns the provided error errorText
  String call(T value) {
    return isValid(value) ? null : errorText;
  }
}

abstract class TextFieldValidator extends FieldValidator<String> {
  TextFieldValidator(String errorText) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  bool get ignoreEmptyValues => true;

  @override
  String call(String value) {
    return (ignoreEmptyValues && value.isEmpty) ? null : super.call(value);
  }

  /// helper function to check if an input matches a given pattern
  bool hasMatch(String pattern, String input, {bool caseSensitive: true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);
}

class RequiredValidator extends TextFieldValidator {
  RequiredValidator({@required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  String call(String value) {
    return isValid(value) ? null : errorText;
  }
}

class MaxLengthValidator extends TextFieldValidator {
  final int max;

  MaxLengthValidator(this.max, {@required String errorText}) : super(errorText);

  @override
  bool isValid(String value) {
    return value.length <= max;
  }
}

class MinLengthValidator extends TextFieldValidator {
  final int min;

  MinLengthValidator(this.min, {@required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    return value.length >= min;
  }
}

class LengthRangeValidator extends TextFieldValidator {
  final int min;
  final int max;

  @override
  bool get ignoreEmptyValues => false;

  LengthRangeValidator({@required this.min, @required this.max, @required String errorText})
      : super(errorText);

  @override
  bool isValid(String value) {
    return value.length >= min && value.length <= max;
  }
}

class RangeValidator extends TextFieldValidator {
  final num min;
  final num max;

  RangeValidator({@required this.min, @required this.max, @required String errorText})
      : super(errorText);

  @override
  bool isValid(String value) {
    try {
      final numericValue = num.parse(value);
      return (numericValue >= min && numericValue <= max);
    } catch (_) {
      return false;
    }
  }
}

class EmailValidator extends TextFieldValidator {
  /// regex pattern to validate email inputs.
  final Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidator({@required String errorText}) : super(errorText);

  @override
  bool isValid(String value) => hasMatch(_emailPattern, value, caseSensitive: false);
}

class PatternValidator extends TextFieldValidator {
  final Pattern pattern;
  final bool caseSensitive;

  PatternValidator(this.pattern, {@required String errorText, this.caseSensitive = true})
      : super(errorText);

  @override
  bool isValid(String value) => hasMatch(pattern, value, caseSensitive: caseSensitive);
}

class DateValidator extends TextFieldValidator {
  final String format;

  DateValidator(this.format, {@required String errorText}) : super(errorText);

  @override
  bool isValid(String value) {
    try {
      final dateTime = DateFormat(format).parseStrict(value);
      return dateTime != null;
    } catch (_) {
      return false;
    }
  }
}

class MultiValidator extends FieldValidator {
  final List<FieldValidator> validators;
  static String _errorText = '';

  MultiValidator(this.validators) : super(_errorText);

  @override
  bool isValid(value) {
    for (FieldValidator validator in validators) {
      if (validator.call(value) != null) {
        _errorText = validator.errorText;
        return false;
      }
    }
    return true;
  }

  @override
  String call(dynamic value) {
    return isValid(value) ? null : _errorText;
  }
}

/// a special match validator to check if the input equals another provided value;
class MatchValidator {
  final String errorText;

  MatchValidator({@required this.errorText});

  String validateMatch(String value, String value2) {
    return value == value2 ? null : errorText;
  }
}
