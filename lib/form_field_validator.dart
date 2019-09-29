library form_field_validator;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// same function signature as FormTextField's validator;
typedef ValidatorFunction<T> = T Function(T value);

abstract class FieldValidator<T> {
  /// the message to display when the validation fails
  final String message;

  /// ignore empty values if true
  final bool optional;

  FieldValidator(this.message, this.optional)
      : assert(message != null),
        assert(optional != null);

  /// checks the input against the implemented conditions
  bool isValid(T value);

  /// returns null if the input is valid otherwise it returns the provided error message
  String validate(T value) {
    return isValid(value) ? null : message;
  }

  /// helper function to check if an input matches a given pattern
  bool hasMatch(String pattern, String input) => RegExp(pattern).hasMatch(input);
}

abstract class TextFormFieldValidator extends FieldValidator<String> {
  TextFormFieldValidator(String message, bool optional) : super(message, optional);

  @override
  String validate(String value) {
    if (optional && value.isEmpty)
      return null;
    else
      return super.validate(value);
  }
}

class RequiredValidator extends TextFormFieldValidator {
  RequiredValidator({@required String message}) : super(message, false);

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class MaxLengthValidator extends TextFormFieldValidator {
  final int max;

  MaxLengthValidator(this.max, {@required String message, bool optional = false}) : super(message, optional);

  @override
  bool isValid(String value) {
    return value.length <= max;
  }
}

class MinLengthValidator extends TextFormFieldValidator {
  final int min;

  MinLengthValidator(this.min, {@required String message, bool optional = false}) : super(message, optional);

  @override
  bool isValid(String value) {
    return value.length >= min;
  }

}

class LengthRangeValidator extends TextFormFieldValidator {
  final int min;
  final int max;

  LengthRangeValidator(this.min, this.max, {@required String message}) : super(message, false);

  @override
  bool isValid(String value) {
    return value.length >= min && value.length <= max;
  }
}

class RangeValidator extends TextFormFieldValidator {
  final num min;
  final num max;

  RangeValidator({@required this.min, @required this.max, @required String message, bool optional = false}) : super(message, optional);

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

class EmailValidator extends TextFormFieldValidator {
  /// regex pattern to validate email inputs.
  final String _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidator({bool optional = false, @required String message}) : super(message, optional);

  @override
  bool isValid(String value) => hasMatch(_emailPattern, value);
}

class PatternValidator extends TextFormFieldValidator {
  final RegExp regExp;

  PatternValidator(this.regExp, {@required String message, bool optional = false}) : super(message, optional);

  @override
  bool isValid(String value) => regExp.hasMatch(value);
}

class DateValidator extends TextFormFieldValidator {
  final String format;
  DateValidator(this.format, {@required String message, bool optional = false}) : super(message, optional);
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
  final List<FieldValidator<String>> validators;
   static String _errorMessage = '';
  MultiValidator(this.validators) : super(_errorMessage, false);

  @override
  bool isValid(value) {
    for (FieldValidator validator in validators) {
       if(!validator.isValid(value)) {
         _errorMessage = validator.message;
         return false;
       }
    }
    return true;
  }

  @override
  String validate(dynamic value) {
     return isValid(value) ? null : _errorMessage;
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

