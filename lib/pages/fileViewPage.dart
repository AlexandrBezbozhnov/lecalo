import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                          deleteFile(context);
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
