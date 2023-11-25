import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'file_view_page.dart';

class FolderContentsPage extends StatelessWidget {
  final String folderName;
  final List<String> contents;

  const FolderContentsPage({
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
        title: Text('Содержимое папки $folderName'),
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

              String fileName = itemName.split('/').last;

              return ListTile(
                title: Text(fileName),
                onTap: () async {                  
                    await downloadAndShowFileContents(context, itemName);
                },
              );
            },
          );
  }
}
