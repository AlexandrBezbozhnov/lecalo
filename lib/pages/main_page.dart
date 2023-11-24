import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path; // Импорт библиотеки path
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'file_view_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<String>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = fetchUploadedFiles();
  }

  Future<void> downloadAndShowFileContents(String fileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads/$fileName');

    try {
      File localFile =
          File('${(await getTemporaryDirectory()).path}/$fileName');
      await reference.writeToFile(localFile);

      String contents = await localFile.readAsString();

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

  Future<List<String>> fetchUploadedFiles() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads');

    try {
      ListResult result = await reference.listAll();
      List<String> items = result.items.map((item) => item.name).toList();
      List<String> prefixes =
          result.prefixes.map((prefix) => prefix.fullPath).toList();

      List<String> filesAndFolders = [];
      filesAndFolders.addAll(items);
      filesAndFolders.addAll(prefixes);

      return filesAndFolders;
    } catch (error) {
      print('Ошибка при получении файлов из Firebase Storage: $error');
      throw error;
    }
  }

  Future<void> createFolder(String folderName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads/$folderName/');

    try {
      // Создаем файл внутри папки, это создаст папку в Firebase Storage
      await reference.child('/.keep').putData(Uint8List(0));

      setState(() {
        futureFiles =
            fetchUploadedFiles(); // Обновление списка после создания папки
      });
    } catch (error) {
      print('Ошибка при создании папки: $error');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      futureFiles = fetchUploadedFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<String>>(
          future: futureFiles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Нет загруженных файлов'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String itemName = snapshot.data![index];
                  bool isFolder = itemName.endsWith('/');

                  String fileName = path
                      .basename(itemName); // Получаем только имя файла без пути

                  return ListTile(
                    title: Text(fileName), // Отображаем только имя файла
                    onTap: () {
                      if (isFolder) {
                        print('Вы выбрали папку: $itemName');
                      } else {
                        downloadAndShowFileContents(itemName);
                      }
                    },
                    leading: isFolder ? Icon(Icons.folder) : null,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newFolderName = ''; // Хранение имени новой папки

              return AlertDialog(
                title: Text('Новая папка'),
                content: TextField(
                  onChanged: (value) {
                    newFolderName = value; // Сохранение введенного значения
                  },
                  decoration: InputDecoration(hintText: 'Введите имя папки'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      createFolder(newFolderName); // Создание новой папки
                      Navigator.of(context).pop();
                    },
                    child: Text('Создать'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}