import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:iovbulkmailapp/res/fontres.dart';
import 'package:iovbulkmailapp/screens/home_view.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bulk Mail 2nd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: FontRes.semiBold,
        primaryColor: Colors.orange,
      ),
      home: const HomeView(),
    );
  }
}