# form_field_validator

A straightforward flutter form field validator that provides common validation options.

## Usage


```dart
     // use directly in a TextFormField widget
     TextFormField(
         validator: EmailValidator(
       message: 'invalid email address',
     ).validate);
   
     // this is the same as
     TextFormField(
         validator: (val) => EmailValidator(
               message: 'invalid email address',
             ).validate(val));
   
     // define a reusable instance
     final ageValidator = RangeValidator(
       min: 18,
       max: 25,
       message: 'age must be between 18 and 25',
     );
   
     TextFormField(validator: ageValidator.validate);
   
     // for a shorter setup
     final requiredField = RequiredValidator(message: 'this field is required').validate;
   

```

## Multi rules validation 

```dart

  final passwordValidator = MultiValidator([
    RequiredValidator(message: 'password is required'),
    MinLengthValidator(8, message: 'password must contain at least 8 chararecters'),
    PatternValidator(RegExp('(?=.*?[#?!@\$%^&*-])'), message: 'passwords must have at least one special charecter')
  ]);

  String password;

  Form(
    key: _formKey,
    child: Column(children: [
      TextFormField(
        obscureText: true,
        onChanged: (val) => password = val,
        /// call the multi validator function just like any validator
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
  
  class LYDPhoneValidator extends FormFieldValidatorBase<String> {
    LYDPhoneValidator({String message = 'enter an lyd valid phone number', bool optional = false}) : super(message, optional);
  
    @override
    String validate(String value) {
      /// don't validate empty values if the field is optional
      if (value.isEmpty && optional)
        return null;
      else
        // return null if the input is valid otherwise return the error message
        return hasMatch('^((\+|00)?218|0?)?(9[0-9]{8})\$', value) ? null : message;
    }
  }
    /// then simply use it like
    TextFormField(validator: LYDPhoneValidator().validate);

  ```