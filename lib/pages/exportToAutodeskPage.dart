import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExportToAutodeskPage extends StatefulWidget {
  @override
  _ExportToAutodeskPageState createState() => _ExportToAutodeskPageState();
}

class _ExportToAutodeskPageState extends State<ExportToAutodeskPage> {
  List<String> uploadedFiles = [];
  int selectedFileIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('uploads');

    try {
      ListResult result = await reference.listAll();
      List<String> files = result.items.map((item) => item.name).toList();
      setState(() {
        uploadedFiles = files;
      });
    } catch (error) {
      print('Ошибка при получении файлов из Firebase Storage: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Экспорт в Autodesk'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: uploadedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFileIndex = index;
                      });
                    },
                    child: Text(
                      uploadedFiles[index],
                      style: TextStyle(
                        color: selectedFileIndex == index
                            ? Colors.blue // Цвет при выборе
                            : Colors.black, // Цвет при не выборе
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedFileIndex != -1) {
                String selectedFile = uploadedFiles[selectedFileIndex];
                // Получение содержимого файла и отображение в диалоговом окне
                showFileContentDialog(selectedFile);
              }
            },
            child: Text('Создать код для лекала'),
          ),
        ],
      ),
    );
  }

  // Функция для отображения содержимого файла в диалоговом окне

  void showFileContentDialog(String fileName) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('uploads/$fileName');
      final fileData = await reference.getData();

      String fileContents = utf8.decode(fileData!);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Содержимое файла: $fileName'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(fileContents),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: fileContents));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Содержимое скопировано')),
                        );
                      },
                      child: Text('Скопировать'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Закрыть'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      print('Ошибка при получении содержимого файла: $error');
    }
  }
}
