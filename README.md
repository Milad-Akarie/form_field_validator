# form_field_validator  
  
A straightforward flutter form field validator that provides common validation options.
  
## Usage  
  
  
```dart  
     // assign it directly to a TextFormField validator  
     // you don't have the pass the value your self like  
     // validator: (value) => EmailValidator(errorText: 'invalid email address').call(value)  

     // accepts empty value
     TextFormField(  
         validator: EmailValidator(errorText: 'enter a valid email address')  
         );  

     // require a value   
     TextFormField(  
         validator: EmailValidator(errorText: 'enter a valid email address', required: true)  
         );  

     // create a reusable instance  
     final requiredValidator = RequiredValidator(errorText: 'this field is required');  
     
     // again assign it directly to the validator  
     TextFormField(validator: requiredValidator);  
     
```
*Note that all validators (except `RequiredValidator`) accept empty values by default from
version 2.0.0.*

To require a value, either pass `required: true` argument to validator's constructor or
use `MutliValidator`
  
## Multi rules validation

Use this to combine multiple validators. When you require a value, add `RequiredValidator`
as all other validators do not require a value by default.

```dart  
   
  final passwordValidator = MultiValidator([  
    RequiredValidator(errorText: 'password is required'),  
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),  
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')  
 ]);  
  
  String password;  
  
  Form(  
    key: _formKey,  
    child: Column(children: [  
      TextFormField(  
        obscureText: true,  
        onChanged: (val) => password = val,  
        // assign the the multi validator to the TextFormField validator  
        validator: passwordValidator,  
      ),  
  
      // using the match validator to confirm password  
      TextFormField(  
        validator: (val) => MatchValidator(errorText: 'passwords do not match').validateMatch(val, password),  
      )  
    ]),  
  );  
    
 ```
 ## Make your own validator  
 
```dart  
   
class LYDPhoneValidator extends TextFieldValidator {  
    // pass the error text and the `required` flag to the super constructor   
    LYDPhoneValidator({
        String errorText = 'enter a valid LYD phone number',
        bool? required})
    : super(errorText, required: required);  
  
    @override  
    bool isValid(String value) {  
    // return true if the value is valid according the your condition  
    return hasMatch(r'^((+|00)?218|0?)?(9[0-9]{8})$', value);  
    }  
}  

// use it by assigning it to the TextFormField validator  
TextFormField(validator: LYDPhoneValidator());  


  
// you can also extend the base FieldValidator class   
// to work with non string values  
class CustomValidator extends FieldValidator<T>{  
    CustomValidator(String errorText) : super(errorText);  
    
    @override  
    bool isValid(T value) {  
        // TODO: implement isValid  
        return //condition;
    }  
}  
 ```
