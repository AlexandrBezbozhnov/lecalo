import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/mainPage.dart';
import 'pages/CreatePatternPage.dart';
import 'pages/exportToAutodeskPage.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart'; // Для доступа к информации о платформе

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool useMaterial3 = true;
  final List<Widget> _pages = [
    MainPage(),
    CreatePatternPage(),
    ExportToAutodeskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
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
