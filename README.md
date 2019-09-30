# form_field_validator  
  
A straightforward flutter form field validator that provides common validation options.  
  
## Usage  
  
  
```dart  
     // assign it directly to a TextFormField validator  
     // you don't have the pass the value your self like  
     // validator: (value) => EmailValidator(errorText: 'invalid email address').call(value)  
       
     TextFormField(  
         validator: EmailValidator(errorText: 'enter a valid email address')  
         );  
   
     // create a reusable instance  
     final requiredValidator = RequiredValidator(errorText: 'this field is required');  
     
     // again assign it directly to the validator  
     TextFormField(validator: requiredValidator);  
     
```  
  
## Multi rules validation   

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
   
class PhoneValidator extends TextFieldValidator {  
  // pass the error text to the super constructor  
  PhoneValidator({String errorText = 'enter a valid LYD phone number'}) : super(errorText);  
  
  // return false if you want the validator to return error  
  // message when the value is empty.  
  @override  
   bool get ignoreEmptyValues => true;  
    
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
	    return null;  
	  }  
  }  
  
 ```