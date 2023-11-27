import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';
import 'folderContentsPageBAS.dart';

class ExportToAutodeskPage extends StatefulWidget {
  @override
  _ExportToAutodeskPageState createState() => _ExportToAutodeskPageState();
}

class _ExportToAutodeskPageState extends State<ExportToAutodeskPage> {
  late Future<List<String>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = fetchUploadedFiles();
  }

  Future<void> exploreFolderContents(
      String folderName, List<String> items, List<String> folders) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FolderContentsPageBAS(
            folderName: folderName,
            contents: items, // Передаем только содержимое папки
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

  Future<void> _refresh() async {
    setState(() {
      futureFiles = fetchUploadedFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autodesk'),
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
                  if (itemName.endsWith('.txt')) {
                    return SizedBox.shrink(); // Пропуск отображения файла .txt
                  }
                  bool isFile = itemName.endsWith('.');
                  bool isFolder =
                      !isFile; // Проверяем, является ли элемент папкой
                  String fileName = path.basename(itemName);
                  return ListTile(
                    leading: isFolder
                        ? Icon(Icons.folder)
                        : null, // Добавляем иконку для папки
                    title: Text(fileName),
                    onTap: () async {
                      try {
                        ListResult result = await FirebaseStorage.instance
                            .ref()
                            .child(itemName)
                            .listAll();
                        List<String> items =
                            result.items.map((item) => item.fullPath).toList();
                        List<String> folders = result.prefixes
                            .map((folder) => folder.fullPath)
                            .toList();
                        exploreFolderContents(itemName, items, folders);
                      } catch (error) {
                        print('Ошибка при открытии папки: $error');
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
