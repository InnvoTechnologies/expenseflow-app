import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String kBaseUrl = 'https://app.shift2go.io/api';
const String kCdnUrl = '';

EdgeInsets kDefaultPadding = EdgeInsets.symmetric(horizontal: 8);

showSuccessSnackbar(String title) {
  Fluttertoast.showToast(
    msg: title,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

showFailedSnackbar(String title) {
  Fluttertoast.showToast(
    msg: title,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

showToast(String title) {
  Fluttertoast.showToast(
    msg: title,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Color convertColorStringToFlutterColor(String colorString) {
  String formattedColorString = colorString.replaceAll('#', '0xFF');
  int colorValue = int.parse(formattedColorString);
  return Color(colorValue);
}
