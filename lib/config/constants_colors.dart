import 'dart:ui';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF2196f3);
const kSecondaryColor = Color(0xFF0a88ea);
const kDarkPrimaryColor = Color(0xFF005594);
const kWhiteColor = Color(0xFFffffff);
const kGreenColor = Color(0xff41a00f);
const kDarkColor = Color(0xFF000000);
const kErrorColor = Color(0xFF900000);
const kGrayColor = Color(0xFAC2C2C2);


Color _getPriorityColor(priority) {
  switch (priority) {
    case "Urgente":
      return Colors.red;
    case "Haute":
      return Colors.orange;
    case "Moyenne":
      return Colors.yellow;
    case "Basse":
      return Colors.green;
    default:
      return kGrayColor;
  }
}

Color _getStatusColor(status) {
  switch (status) {
    case "En attente":
      return Colors.blue;
    case "En cours":
      return Colors.orange;
    case "Terminé":
      return Colors.green;
    case "Annulé":
      return Colors.red;
    default:
      return kGrayColor;
  }
}