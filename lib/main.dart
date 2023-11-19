// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jadkul/pages/add_class.dart';
import 'package:jadkul/pages/add_schedule.dart';
import 'package:jadkul/pages/edit_class.dart';
import 'package:jadkul/pages/main_page.dart';


void main() async {

  await Hive.initFlutter();

  var box = await Hive.openBox("myBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/mainpage": (context) => MainPage(),
        "/addclasspage": (context) => AddClassPage(),
        "/addschedulepage": (context) => AddSchedulePage(),
        "/editclasspage": (context) => EditClassPage()
      },
      home:  MainPage(),
    );
  }
}