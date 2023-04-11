String validateFirstName(String value) {
  value = value.replaceAll(RegExp(' +'), ' ');
  if (value.length == 0) {
    return "Please enter your first name";
  } else if (value.length <= 2) {
    return "Name must be more than 2 characters";
  } else {
    return null;
  }
}

String validateLastName(String value) {
  value = value.replaceAll(RegExp(' +'), ' ');
  if (value.length == 0) {
    return "Please enter your last name";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  value = value.replaceAll(RegExp(' +'), ' ');
  if (value.length == 0) {
    return "Please enter your email";
  }
  if (!regex.hasMatch(value)) {
    return "Please enter valid email";
  } else {
    return null;
  }
}
