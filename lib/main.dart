import 'dart:io';
import 'package:consec/login.dart';
import 'package:flutter/material.dart';

// Http isteklerinin düzenlenmesini sağlayan sınıf
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main()
{
  // Giriş sayfasını açan fonksiyon.
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MaterialApp(home: ConSecLogin()));
}