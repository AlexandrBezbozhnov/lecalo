import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';
import 'folderContentsPage.dart';

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

  Future<void> deleteFolderAndFiles(String folderName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('$folderName/');

    try {
      // Получаем список файлов и подпапок в папке
      ListResult result = await reference.listAll();
      List<Reference> filesToDelete = result.items;
      List<Reference> foldersToDelete = result.prefixes;

      // Удаляем файлы в папке
      await Future.forEach(filesToDelete, (fileRef) async {
        await fileRef.delete();
      });

      // Удаляем подпапки рекурсивно
      await Future.forEach(foldersToDelete, (folderRef) async {
        await deleteFolderAndFiles(folderRef.fullPath);
      });

      // Удаляем саму папку
      await reference.delete();

    } catch (error) {
      print('Ошибка при удалении папки: $error');
      setState(() {
        futureFiles =
            fetchUploadedFiles(); // Обновляем список файлов после удаления
      });
    }
  }

  Future<void> exploreFolderContents(
      String folderName, List<String> items, List<String> folders) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FolderContentsPage(
            folderName: folderName,
            contents: items, // Передаем только содержимое папки
          ),
        ),
      );
    } catch (error) {
      print('Ошибка при чтении содержимого папки: $error');
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
    Reference reference = storage.ref().child('uploads/');

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
      await reference.child('/.keep').putData(Uint8List(0));

      setState(() {
        futureFiles = fetchUploadedFiles();
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
                bool isFile = itemName.endsWith('.txt');
                bool isFolder = !isFile; // Проверяем, является ли элемент папкой

                String fileName = path.basename(itemName);

                return ListTile(
                  leading: isFolder ? Icon(Icons.folder) : null, // Добавляем иконку для папки
                  title: Text(fileName),
                  onTap: () async {
                    if (isFile) {
                      downloadAndShowFileContents(itemName);
                    } else {
                      try {
                        ListResult result = await FirebaseStorage.instance
                            .ref()
                            .child(itemName)
                            .listAll();
                        List<String> items = result.items
                            .map((item) => item.fullPath)
                            .toList();
                        List<String> folders = result.prefixes
                            .map((folder) => folder.fullPath)
                            .toList();
                        exploreFolderContents(itemName, items, folders);
                      } catch (error) {
                        print('Ошибка при открытии папки: $error');
                      }
                    }
                  },
                  onLongPress: () {
                    if (!isFile) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Удалить папку и все файлы?'),
                            content: Text(
                                'Вы уверены, что хотите удалить эту папку и все файлы в ней?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteFolderAndFiles(itemName);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Удалить'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
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
            String newFolderName = '';

            return AlertDialog(
              title: Text('Новая папка'),
              content: TextField(
                onChanged: (value) {
                  newFolderName = value;
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
                    createFolder(newFolderName);
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