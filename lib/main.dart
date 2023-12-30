import 'package:assistant_app/colors.dart';
import 'package:assistant_app/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
     // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple
        scaffoldBackgroundColor: Pallete.whiteColor
      ),
      home: const HomePage(),
    );
  }
}

