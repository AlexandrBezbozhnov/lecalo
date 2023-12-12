import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart'; // Import flutter/services.dart
import 'EditFilePage.dart';
import 'dart:convert';// Import the page for file editing

class FileViewPage extends StatefulWidget {
  final String fileName;
  final String fileContents;
  final String folderName;

  FileViewPage({
    required this.fileName,
    required this.fileContents,
    required this.folderName,
  });

  @override
  _FileViewPageState createState() => _FileViewPageState();
}

class _FileViewPageState extends State<FileViewPage> {
  late String fileContents;

  @override
  void initState() {
    super.initState();
    fileContents = widget.fileContents;
  }

  Future<void> deleteFile(
      BuildContext context, String fileName, String folderName) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('$folderName');
      print(reference);

      await reference.delete();
      Navigator.popUntil(context, ModalRoute.withName('/'));
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      print('Error deleting file: $error');
    }
  }

  Future<void> copyFileContentsToClipboard(String fileContents) async {
    try {
      await Clipboard.setData(ClipboardData(text: fileContents));
      print('File contents copied to clipboard');
    } catch (error) {
      print('Error copying to clipboard: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
                          deleteFile(
                              context, widget.fileName, widget.folderName);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedFileContents = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditFilePage(fileContents: fileContents),
                ),
              );

              if (updatedFileContents != null) {
                setState(() {
                  fileContents = updatedFileContents;
                });

                try {
                  final FirebaseStorage storage = FirebaseStorage.instance;
                  Reference reference =
                      storage.ref().child(widget.folderName);
                  print(reference);
                  // Преобразуем обновленное содержимое файла (строку) в Uint8List
                  List<int> bytes = utf8.encode(updatedFileContents);
                  // Загружаем обновленное содержимое в Firebase Storage
                  await reference.putData(Uint8List.fromList(bytes));

                  print('Содержимое файла обновлено в Firebase Storage');
                } catch (error) {
                  print(
                      'Ошибка при обновлении содержимого файла в Firebase Storage: $error');
                }
              }
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
