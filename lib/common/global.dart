import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
var authToken;
Color spcl = Color(0xff655586);
var selectedCurrency;
var selectedCurrencyRate;
var langCode;
List<BoxShadow> boxShadow1 = [
  BoxShadow(
      color: Colors.black26.withOpacity(0.10),
      blurRadius: 6,
      offset: Offset(2.0, 5.0),
      spreadRadius: 2.0)
];
