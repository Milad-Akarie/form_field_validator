import 'package:flutter_test/flutter_test.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  group('RequiredValidator test', () {
    final String errorText = 'invalid input message';
    final requiredValidator = RequiredValidator(errorText: errorText);

    test('calling validate with an empty value will return $errorText', () {
      expect(errorText, requiredValidator(''));
    });

    test('calling validate with a value will return null', () {
      expect(null, requiredValidator('valid input'));
    });
  });

  group('EmailValidator test', () {
    final String errorText = 'invalid input message';
    final emailValidator = EmailValidator(errorText: errorText);

    test('calling validate with an invalid email will return $errorText', () {
      expect(errorText, emailValidator('invalidEmaial.com'));
    });

    test('calling validate with a valid email will return null', () {
      expect(null, emailValidator('me@email.com'));
      expect(null, emailValidator('Me@email.com'));
    });
  });

  group('MaxLenghtValidator test', () {
    final String errorText = 'invalid input message';
    final maxLengthValidator = MaxLengthValidator(15, errorText: errorText);

    test('calling validate with a string greater then 15 charecters will return error text', () {
      expect(errorText, maxLengthValidator('text greater than 15 charecters'));
    });

    test('calling validate with a string equal or less then 15 charecters will return null', () {
      expect(null, maxLengthValidator('valid input'));
    });
  });

  group('MinLenghtValidator test', () {
    final String errorText = 'invalid input message';
    final minLengthValidator = MinLengthValidator(5, errorText: errorText);

    test('calling validate with a string < 5 charecters will return $errorText', () {
      expect(errorText, minLengthValidator('text'));
    });

    test('calling validate with a string >= 5 charecters will return null', () {
      expect(null, minLengthValidator('valid text'));
    });
  });

  group('LengthRangeValidator test', () {
    final errorText = 'invalid input message';
    final lengthRangeValidator = LengthRangeValidator(min: 3, max: 10, errorText: errorText);

    test('calling validate with a string less then 3 or greater than 10 charecters will return error text', () {
      expect(errorText, lengthRangeValidator('sh'));
      expect(errorText, lengthRangeValidator('more than 10 characters message'));
    });

    test('calling validate with a string equal or less then 15 charecters will return null', () {
      expect(null, lengthRangeValidator('valid'));
    });
  });

  group('RangeValidator test', () {
    final errorText = 'invalid input message';
    final rangeValidator = RangeValidator(min: 18, max: 32, errorText: errorText);

    test('calling validate with < 18 or > 32  will return error text', () {
      expect(errorText, rangeValidator('16'));
    });

    test('calling validate with >= 18 and <= 32 will return null', () {
      expect(null, rangeValidator('20'));
    });
  });

  group('PatternValidator test', () {
    final errorText = 'invalid input message';
    final patternValidator = PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: errorText);

    test('calling validate with no special char will return error text', () {
      expect(errorText, patternValidator('invalid'));
    });

    test('calling validate with at least one special char will return null', () {
      expect(null, patternValidator('*'));
    });

    final caseSensitivePatternValidator = PatternValidator(r'[a-z]', errorText: errorText);
    test('calling validate with no lower case char will return error text', () {
      expect(errorText, caseSensitivePatternValidator('A'));
    });

    test('calling validate with at least one lower case char will return null', () {
      expect(null, caseSensitivePatternValidator('a'));
    });

    final caseInsensitivePatternValidator = PatternValidator(r'[a-z]', errorText: errorText, caseSensitive: false);
    test('calling validate with no lower or upper case char will return error text', () {
      expect(errorText, caseInsensitivePatternValidator('*'));
    });

    test('calling validate with at least one lower case char will return null', () {
      expect(null, caseInsensitivePatternValidator('a'));
    });

    test('calling validate with at least one upper case char will return null', () {
      expect(null, caseInsensitivePatternValidator('A'));
    });
  });

  group('DateValidator test', () {
    final errorText = 'invalid input message';
    final dateValidator = DateValidator('dd/mm/yyyy', errorText: errorText);

    test('calling validate with a date that does not matche the given format will return error text', () {
      expect(errorText, dateValidator('12-12-2020'));
    });

    test('calling validate with a date that matches the given format will return null', () {
      expect(null, dateValidator('12/12/2020'));
    });
  });

  group('MultiValidator test', () {
    final String requiredErrorText = 'field is required';
    final String maxLengthErrorText = 'max lenght is 15';
    final multiValidator = MultiValidator([
      RequiredValidator(errorText: requiredErrorText),
      MaxLengthValidator(15, errorText: maxLengthErrorText),
    ]);

    test('calling validate with an empty value will return $requiredErrorText', () {
      expect(requiredErrorText, multiValidator(''));
    });

    test('calling validate with a string > 15 charecters will return $maxLengthErrorText', () {
      expect(maxLengthErrorText, multiValidator('a long text that contains more than 15 chars'));
    });

    test('calling validate with a string <= 15 charecters will return null', () {
      expect(null, multiValidator('short text'));
    });
  });
}
