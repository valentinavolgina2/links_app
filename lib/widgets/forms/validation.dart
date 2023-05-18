import 'package:string_validator/string_validator.dart';

const listNameMaxLength = 50;
const linkNameMaxLength = 100;

String? listNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  return null;
}

String? linkNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  return null;
}

String? linkUrlValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Url is required';
  } else if (!isURL(value)) {
    return 'Not valid url';
  }
  return null;
}

String? emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Url is required';
  }
  return null;
}

String? passwordValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Url is required';
  }
  return null;
}
