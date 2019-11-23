```Dart

     // assign it directly to a TextFormField validator
     TextFormField(
         validator: EmailValidator(errorText: 'enter a valid email address')
         );

     // create a reusable instance
     final requiredValidator = RequiredValidator(errorText: 'this field is required');

     // again assign it directly to the validator
     TextFormField(validator: requiredValidator);
```