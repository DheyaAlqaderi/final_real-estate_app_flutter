
class SRValidator {
  static String? validateEmail(String? email) {
    // Regular expression for email validation
    final RegExp emailRegex =
    RegExp(r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

    if (email!.isEmpty) {
      return 'Please enter an email address.';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null; // Return empty string if email is valid
  }
  static String? validateYemeniPhoneNumber(String? phoneNumber) {
    // Regular expression for Yemeni phone number validation
    final RegExp phoneRegex = RegExp(r'^009677[3,7,8,1,0]{1}[0-9]{7}$');

    if (phoneNumber!.isEmpty) {
      return 'Please enter a phone number.';
    } else if (!phoneRegex.hasMatch(phoneNumber)) {
      return 'Please enter a valid Yemeni phone number';
    }

    return null; // Return empty string if phone number is valid
  }
}