import 'package:flutter/material.dart';
import 'package:tabuadai9/home/home_page.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tabuada I9',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xff042a49)),
      ),
      home: HomePage(),
    );
  }
}