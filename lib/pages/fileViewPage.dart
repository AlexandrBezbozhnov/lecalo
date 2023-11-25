import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'mainPage.dart';

class FileViewPage extends StatelessWidget {
  final String fileName;
  final String fileContents;

  FileViewPage({required this.fileName, required this.fileContents});

  Future<void> deleteFile(BuildContext context) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('$fileName');

      await reference.delete();
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      print('Ошибка при удалении файла: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fileName'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Удалить файл'),
                    onTap: () {
                      deleteFile(context);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(fileContents),
        ),
      ),
    );
  }
}
