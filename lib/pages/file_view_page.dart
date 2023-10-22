import 'package:flutter/material.dart';

class FileViewPage extends StatelessWidget {
  final String fileName;
  final String fileContents;

  FileViewPage({required this.fileName, required this.fileContents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Содержимое файла: $fileName'),
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
