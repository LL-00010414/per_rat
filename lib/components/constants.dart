
//constants
const double buttonFontSize = 14;


// Utility function to get display email
String getDisplayEmail(String email) {
  //if (email == null || email.isEmpty) return '';
  return email.substring(0, email.indexOf('@')).length <= 12
      ? email.substring(0, email.indexOf('@'))
      : email.substring(0, 12) + '...';
}
