import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';

class FolderContentsPageBAS extends StatelessWidget {
  final String folderName;
  final List<String> contents;

  const FolderContentsPageBAS({
    Key? key,
    required this.folderName,
    required this.contents,
  }) : super(key: key);

  Future<void> downloadAndShowFileContents(
      BuildContext context, String fileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('$fileName/');

    try {
      File localFile =
          File('${(await getTemporaryDirectory()).path}/$fileName');
      await reference.writeToFile(localFile);

      String fileContents = await localFile.readAsString();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileViewPage(
            fileName: fileName,
            fileContents: fileContents,
          ),
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
        title: Text('$folderName'),
      ),
      body: _buildContentsList(context),
    );
  }

  Widget _buildContentsList(BuildContext context) {
    return contents.isEmpty
        ? Center(child: Text('Папка пуста'))
        : ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              String itemName = contents[index];

              // Проверка на расширение файла .keep и пропуск его отображения
              if (itemName.endsWith('.keep')) {
                return SizedBox.shrink(); // Пропуск отображения файла .keep
              }
              if (itemName.endsWith('.txt')) {
                return SizedBox.shrink(); // Пропуск отображения файла .keep
              }
              String fileName = itemName.split('/').last;
              // Удаление расширения .txt из имени файла
              if (fileName.endsWith('.bas')) {
                fileName = fileName.substring(0, fileName.length - 4);
              }

              return ListTile(
                title: Text(
                    fileName), // Отображение имени файла без расширения .txt
                onTap: () async {
                  await downloadAndShowFileContents(context, itemName);
                },
              );
            },
          );
  }
}
