import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/main_page.dart';
import 'pages/create_pattern_page.dart';
import 'pages/export_to_autodesk_page.dart';
import 'pages/file_view_page.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    CreatePatternPage(),
    ExportToAutodeskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home), // Use Material 3 icons
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create), // Use Material 3 icons
              label: 'Создать',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_export), // Use Material 3 icons
              label: 'Экспорт',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
