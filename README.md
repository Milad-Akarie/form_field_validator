# form_field_validator

A straightforward flutter form field validator that provides common validation options.

## Usage


```dart
     // use it directly in a TextFormField widget
     TextFormField(
         validator: EmailValidator(
       message: 'invalid email address',
     ).validate);
   
     // this is the same as
     TextFormField(
         validator: (val) => EmailValidator(
               message: 'invalid email address',
             ).validate(val));
   
     // create a reusable instance
     final ageValidator = RangeValidator(
       min: 18,
       max: 25,
       message: 'age must be between 18 and 25',
     );
   
     TextFormField(validator: ageValidator.validate);
   
     // for a shorter setup
     final requiredField = RequiredValidator(message: 'this field is required').validate;
     TextFormField(validator: requiredField);

```

## Multi rules validation 

```dart

  final passwordValidator = MultiValidator([
    RequiredValidator(message: 'password is required'),
    MinLengthValidator(8, message: 'password must be at least 8 digits long'),
    PatternValidator(RegExp('(?=.*?[#?!@\$%^&*-])'), message: 'passwords must have at least one special character')
  ]);

  String password;

  Form(
    key: _formKey,
    child: Column(children: [
      TextFormField(
        obscureText: true,
        onChanged: (val) => password = val,
        /// call the multi validator function just like any other validator
        validator: passwordValidator.validate,
      ),

      // using the match validator to confirm password
      TextFormField(
        validator: (val) => MatchValidator(message: 'passwords do not match').validateMatch(val, password),
      )
    ]),
  );
  
  ```
  
  ## Make your own validator
  
  ```dart
  
class LYDPhoneValidator extends TextFormFieldValidator {
  LYDPhoneValidator({String message = 'enter a valid LYD phone number', bool optional = false}) : super(message, optional);
  @override
  bool isValid(String value) {
    return hasMatch('^((\+|00)?218|0?)?(9[0-9]{8})\$', value);
  }
}
    /// use it by assigning it's validate function to the text field validator
    TextFormField(validator: LYDPhoneValidator().validate);

  ```