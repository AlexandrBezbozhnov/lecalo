import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Импортируем flutter/services.dart


class FileViewPage extends StatelessWidget {
  final String fileName;
  final String fileContents;
  final String folderName;

  FileViewPage(
      {required this.fileName,
      required this.fileContents,
      required this.folderName});


  Future<void> deleteFile(BuildContext context, fileName, folderName) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('$folderName');
      print(reference);

      await reference.delete();
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      print('Ошибка при удалении файла: $error');
    }
  }

    Future<void> copyFileContentsToClipboard(String fileContents) async {
    try {
      await Clipboard.setData(ClipboardData(text: fileContents));
      print('Содержимое файла скопировано в буфер обмена');
    } catch (error) {
      print('Ошибка при копировании в буфер обмена: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fileName'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              copyFileContentsToClipboard(fileContents);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete File'),
                    content: Text('Are you sure you want to delete this file?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteFile(context, fileName, folderName);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
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
