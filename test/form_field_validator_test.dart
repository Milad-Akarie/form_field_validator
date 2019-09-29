import 'package:flutter_test/flutter_test.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {

  group('RequiredValidator test', (){
    final String errorMessage = 'field is required';
    final requiredValidator = RequiredValidator(message: errorMessage);

    test('calling validate with an empty value will return $errorMessage', (){
      expect(errorMessage, requiredValidator.validate(''));
    });

    test('calling validate with a value will return null', () {
      expect(null, requiredValidator.validate('valid input'));
    });
  });


  group('MaxLenghtValidator test', (){
    final String errorMessage = 'max lenght is 15';
    final maxLengthValidator = MaxLengthValidator(15, message: errorMessage);

    test('calling validate with a string greater then 15 charecters will return $errorMessage', (){
      expect(errorMessage, maxLengthValidator.validate('short message'));
    });

    test('calling validate with a string equal or less then 15 charecters will return null', () {
      expect(null, maxLengthValidator.validate('valid input'));
    });
  });

  group('MinLenghtValidator test', (){
    final String errorMessage = 'min lenght is 5';
    final minLengthValidator = MinLengthValidator(5, message: errorMessage);

    test('calling validate with a string < 5 charecters will return $errorMessage', (){
      expect(errorMessage, minLengthValidator.validate('text'));
    });

    test('calling validate with a string >= 5 charecters will return null', () {
      expect(null, minLengthValidator.validate('valid text'));
    });
  });
  
  group('MultiValidator test', (){
    final String maxLengthErrorMessage = 'max lenght is 15';
    final String requiredErrorMessage = 'field is required';
    final multiValidator = MultiValidator([
    RequiredValidator(message: requiredErrorMessage),
    MaxLengthValidator(15, message: maxLengthErrorMessage),
    ]);

    test('calling validate with an empty value will return $requiredErrorMessage', (){
      expect (requiredErrorMessage,multiValidator.validate(''));
    });
    test('calling validate with a string > 15 charecters will return $maxLengthErrorMessage', (){
      expect (maxLengthErrorMessage,multiValidator.validate('a long text that contains more than 15 chars'));
    });

    test('calling validate with a string <= 15 charecters will return null', () {
      expect(null, multiValidator.validate('short text'));
    });

  });

}
