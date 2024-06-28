//constants
import 'package:flutter/material.dart';

const double buttonFontSize = 14;
//const double borderRadius = 8;
final BorderRadiusGeometry customBorderGeometry = BorderRadius.circular(8);

//shimmering skeleton constants
const Color primaryColor = Color(0xFF2967FF);
const Color grayColor = Color(0xFF8D8D8E);

const double defaultPadding = 16.0;

// Utility function to get display email
String getDisplayEmail(String email) {
  //if (email == null || email.isEmpty) return '';
  return email.substring(0, email.indexOf('@')).length <= 12
      ? email.substring(0, email.indexOf('@'))
      : email.substring(0, 12) + '...';
}
