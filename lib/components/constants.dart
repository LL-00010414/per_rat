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

//recipient name
Future<String> getRecipientName(String recipientId) async {
  var recipientDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(recipientId)
      .get();
  if (recipientDoc.exists) {
    var recipientData = recipientDoc.data()!;
    return recipientData['username'] ?? recipientData['email'];
  } else {
    return recipientId; // Fallback to recipientId if user document doesn't exist
  }
}

//recipient whole data
Future<Map<String, dynamic>> getRecipientData(String recipientId) async {
  var recipientDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(recipientId)
      .get();
  if (recipientDoc.exists) {
    var recipientData = recipientDoc.data()!;
    return recipientData;
  } else {
    return {
      "Data": "data doesn't exist"
    }; // Fallback to recipientId if user document doesn't exist
  }
}

//timestamp format function
String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('MMM dd, hh:mm a').format(dateTime);
}
