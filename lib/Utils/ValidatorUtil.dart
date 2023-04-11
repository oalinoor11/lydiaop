class ValidatorUtil {
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

  String validateEmailId(String value) {
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

  String validateLidAmount(String value) {
    if (value.length == 0) {
      return "Please enter Lid Quantity";
    } else if (double.parse(value) == 0.0) {
      return "Lid quantiry should be more than 0";
    } else {
      return null;
    }
  }

  String validateWalletAddess(String value) {
    value = value.replaceAll(RegExp(' +'), ' ');
    if (value.length == 0) {
      return "Please write wallet address";
    } else {
      return null;
    }
  }

  String validateNote(String value) {
    value = value.replaceAll(RegExp(' +'), ' ');
    if (value.length == 0) {
      return "Please enter note";
    } else {
      return null;
    }
  }
}
