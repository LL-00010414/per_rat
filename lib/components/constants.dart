//constants
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double buttonFontSize = 14;
//const double borderRadius = 8;
final BorderRadiusGeometry customBorderGeometry = BorderRadius.circular(8);

//shimmering skeleton constants
const Color baseColor = Color(0xFF616161);
const Color highlightColor = Color(0xFF9E9E9E);

// Utility function to get display email
String getDisplayEmail(String email) {
  //if (email == null || email.isEmpty) return '';
  return email.substring(0, email.indexOf('@')).length <= 12
      ? email.substring(0, email.indexOf('@'))
      : email.substring(0, 12) + '...';
}

//timestamp format function
String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('MMM dd, hh:mm a').format(dateTime);
}
