import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/main_page.dart';
import 'pages/create_pattern_page.dart';
import 'pages/export_to_autodesk_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Инициализация Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FolderPage(),
    CreatePatternPage(),
    ExportToAutodeskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Создать',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_export),
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