import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'file_view_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> uploadedFiles = []; // Список для хранения имен файлов

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles(); // Загрузить список загруженных файлов при инициализации страницы
  }

  Future<void> fetchUploadedFiles() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads');

    try {
      ListResult result = await reference.listAll();
      List<String> files = result.items.map((item) => item.name).toList();
      setState(() {
        uploadedFiles = files;
      });
    } catch (error) {
      print('Ошибка при получении файлов из Firebase Storage: $error');
    }
  }

  Future<void> downloadAndShowFileContents(String fileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads/$fileName');

    try {
      File localFile =
          File('${(await getTemporaryDirectory()).path}/$fileName');
      await reference.writeToFile(localFile);

      String contents = await localFile.readAsString();

      // Навигация на новую страницу для отображения содержимого файла
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FileViewPage(fileName: fileName, fileContents: contents),
        ),
      );
    } catch (error) {
      print('Ошибка при загрузке или чтении файла: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Загруженные файлы'),
      ),
      body: ListView.builder(
        itemCount: uploadedFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(uploadedFiles[index]),
            onTap: () {
              downloadAndShowFileContents(uploadedFiles[index]);
            },
          );
        },
      ),
    );
  }
}