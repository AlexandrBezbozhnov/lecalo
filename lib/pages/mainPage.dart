import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'folderContentsPageTXT.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<String>> futureFiles;
  late List<String> originalFilesList = []; // Инициализация переменной
  TextEditingController searchController =
      TextEditingController(); // Контроллер для текстового поля поиска
  bool folderContentsOpened = false; // Добавленная переменная

  @override
  void initState() {
    super.initState();
    futureFiles = fetchUploadedFiles();
  }

  Future<void> deleteFolderAndFiles(String folderName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads/$folderName/');

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
      if (!folderContentsOpened) {
        folderContentsOpened = true; // Установка флага, что страница открыта

        // Открываем страницу FolderContentsPageTXT
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderContentsPageTXT(
              folderName: folderName,
              contents: items,
            ),
          ),
        ).then((_) async {
          folderContentsOpened = false; // Сброс флага после закрытия страницы
          // Загрузка файлов после закрытия страницы FolderContentsPageTXT
          List<String> updatedFiles = await fetchUploadedFiles();
          setState(() {
            futureFiles = Future.value(updatedFiles);
          });
        });
      }
    } catch (error) {
      print('Ошибка при чтении содержимого папки: $error');
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

      // Всплывающая подсказка при успешном создании папки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Папка создана')),
      );
    } catch (error) {
      print('Ошибка при создании папки: $error');
    }
  }

  Future<List<String>> searchFolders(String query) async {
    // Если список исходных файлов не определен, получаем его из Firebase Storage
    if (originalFilesList == null || originalFilesList.isEmpty) {
      try {
        originalFilesList = await fetchUploadedFiles();
      } catch (error) {
        print('Ошибка при получении файлов из Firebase Storage: $error');
        throw error;
      }
    }

    // Если запрос пустой, возвращаем исходный список файлов
    if (query.isEmpty) {
      return originalFilesList;
    }

    // Иначе фильтруем исходный список по запросу
    List<String> filteredList = originalFilesList.where((fileName) {
      return fileName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return filteredList;
  }

  Future<void> _refresh() async {
    setState(() {
      futureFiles = fetchUploadedFiles();
    });
  }

// Добавим функцию для отображения меню действий для папки
  void showFolderActionsMenu(String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Действия с папкой'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Удалить папку и все файлы'),
                onTap: () {
                  deleteFolderAndFiles(folderName);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Переименовать папку'),
                onTap: () {
                  Navigator.of(context).pop();
                  showRenameFolderDialog(folderName);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

// Обновленная функция для переименования папки
  void showRenameFolderDialog(String currentName) {
    String newFolderName = currentName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Переименовать папку'),
          content: TextField(
            onChanged: (value) {
              newFolderName = value;
            },
            decoration: InputDecoration(
              hintText: 'Введите новое имя папки',
            ),
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
                renameFolder(currentName, newFolderName);
                Navigator.of(context).pop();
              },
              child: Text('Переименовать'),
            ),
          ],
        );
      },
    );
  }

  Future<void> renameFolder(String currentName, String newName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads/$currentName/');
    Reference newReference = storage.ref().child('uploads/$newName/');

    try {
      // Получение списка файлов и папок в текущей папке
      ListResult result = await reference.listAll();
      List<Reference> filesToMove = result.items;
      List<Reference> foldersToMove = result.prefixes;

      // Копирование файлов внутри папки с новыми именами
      await Future.forEach(filesToMove, (fileRef) async {
        String oldPath = fileRef.fullPath;
        String newFilePath = 'uploads/$newName/${oldPath.split('/').last}';
        // Получаем URL текущего файла
        String downloadURL = await fileRef.getDownloadURL();
        // Загружаем файл в новую папку
        await uploadFileFromURL(
            newReference.child(oldPath.split('/').last), downloadURL);
      });

      // Создание пустых папок с новыми именами
      await Future.forEach(foldersToMove, (folderRef) async {
        String oldPath = folderRef.fullPath;
        String newFolderPath = 'uploads/$newName/${oldPath.split('/').last}';
        await newReference.child(oldPath.split('/').last).putData(Uint8List(0));
      });

      // Удаление старой папки после завершения всех операций
      await Future.forEach(filesToMove, (fileRef) async {
        await fileRef.delete();
      });

      await Future.forEach(foldersToMove, (folderRef) async {
        await folderRef.delete();
      });

      deleteFolderAndFiles(currentName);

      // Обновление списка файлов после переименования
      setState(() {
        futureFiles = fetchUploadedFiles();
      });

      // Всплывающая подсказка при успешном переименовании папки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Папка переименована')),
      );
    } catch (error) {
      print('Ошибка при переименовании папки: $error');
    }
  }

// Функция для загрузки файла по его URL
  Future<void> uploadFileFromURL(Reference ref, String downloadURL) async {
    http.Response response = await http.get(Uri.parse(downloadURL));
    Uint8List fileData = response.bodyBytes;
    await ref.putData(fileData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    futureFiles = searchFolders(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Поиск папок',
                  hintText: 'Введите название папки для поиска',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: futureFiles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Ошибка загрузки: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Нет результатов'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String itemName = snapshot.data![index];
                        bool isFile = itemName.endsWith('.txt');
                        bool isFolder = !isFile;

                        String fileName = path.basename(itemName);

                        return ListTile(
                          leading: isFolder ? Icon(Icons.folder) : null,
                          title: Text(fileName),
                          onTap: () async {
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
                          },
                          onLongPress: () {
                            if (!isFile) {
                              // Показать меню действий для папки
                              showFolderActionsMenu(fileName);
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
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
        child: Icon(Icons.create_new_folder),
      ),
    );
  }
}
