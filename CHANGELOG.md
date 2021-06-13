## [2.0.0]
All validators have `required: bool` argument which defaults to `false` so empty
values are fine for all validators except `RequiredValidator` which has `required: true`
for obvious reason.
This may break some codes where value is required by default. To achieve this pass
either `required: true` when creating the validator or use `MultiValidator` with
`RequiredValidator` and any other. See README.md for examples.

If you have your own validator(s) and override the `ignoreEmptyValues` getter, remove 
this getter as it doesn't exist in `TextFieldValidator` anymore and replace this with
`required` argument passed to `super()` constructor. See README.md for examples.

## [1.0.1]
### fix intl dependency conflict
### add usage example

## [1.0.0+1]
### typo fix

## [1.0.0]
 * initial release.
