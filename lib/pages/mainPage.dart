import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'folderContentsPageTXT.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<String>> futureFiles;
  late List<String> originalFilesList = []; // Инициализация переменной
  TextEditingController searchController = TextEditingController(); // Контроллер для текстового поля поиска

  @override
  void initState() {
    super.initState();
    futureFiles = fetchUploadedFiles();
  }

  Future<void> deleteFolderAndFiles(String folderName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('$folderName/');

    try {
      ListResult result = await reference.listAll();
      List<Reference> filesToDelete = result.items;
      List<Reference> foldersToDelete = result.prefixes;

      await Future.forEach(filesToDelete, (fileRef) async {
        await fileRef.delete();
      });

      await Future.forEach(foldersToDelete, (folderRef) async {
        await deleteFolderAndFiles(folderRef.fullPath);
      });

      await reference.delete();
    } catch (error) {
      print('Ошибка при удалении папки: $error');
      setState(() {
        futureFiles = fetchUploadedFiles();
      });
    }
  }

  Future<void> exploreFolderContents(
      String folderName, List<String> items, List<String> folders) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FolderContentsPageTXT(
            folderName: folderName,
            contents: items,
          ),
        ),
      );
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


  Future<void> _refresh() async {
    setState(() {
      futureFiles = fetchUploadedFiles();
    });
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
                    return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
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
