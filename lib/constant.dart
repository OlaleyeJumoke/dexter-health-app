import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

printOnlyInDebug(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}

void showFlush(String message, Color color, BuildContext context) {
  Flushbar(
    backgroundColor: color,
    message: message,
    duration: Duration(seconds: 7),
    flushbarStyle: FlushbarStyle.GROUNDED,
  ).show(context);
}

const Color appColor = Colors.teal;
const Color green = Colors.green;
const Color grey = Colors.blueGrey;
const Color white = Colors.white;
const Color red = Color(0xFFED2B30);

//Time formater

extension IntExtension on int {
  String getAbbr() {
    String day = this.toString();
    if (day.endsWith('1') && day != '11')
      return 'st';
    else if (day.endsWith('2') && day != '12')
      return 'nd';
    else if (day.endsWith('3') && day != '13')
      return 'rd';
    else
      return 'th';
  }
}

extension StringDateExtension on DateTime {
  String getStylizedDate() {
    return DateFormat("d'${this.day.getAbbr()}' MMM, yyyy").format(this);
  }
}
