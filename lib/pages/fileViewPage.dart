import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileViewPage extends StatelessWidget {
  final String fileName;
  final String fileContents;
  final String folderName;

  FileViewPage(
      {required this.fileName,
      required this.fileContents,
      required this.folderName});

  Future<void> downloadFile(
      BuildContext context, String fileName, String folderName) async {
    try {
      final PermissionStatus permissionStatus =
          await Permission.storage.request();

      if (permissionStatus.isGranted) {
        final FirebaseStorage storage = FirebaseStorage.instance;
        Reference reference = storage.ref().child('$folderName');
        print(reference);
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/$fileName';
        print(filePath);
        File downloadToFile = File(filePath);

        await reference.writeToFile(downloadToFile);

        // Show a confirmation dialog after successful download
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Download Complete'),
              content: Text('File has been downloaded to your device.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle denied or restricted permission
        // You can show an alert or request permission again
      }
    } catch (error) {
      print('Ошибка при скачивании файла: $error');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fileName'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              downloadFile(context, fileName, folderName);
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
