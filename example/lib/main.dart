import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'PDF Scanner & Editor',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

