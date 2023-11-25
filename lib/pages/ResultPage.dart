import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'main_page.dart';
import 'dart:async';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;
  final List<String> userMeasurements;

  ResultPage(
    this.calculatedMeasurements,
    this.measurementNames,
    this.userMeasurements,
  );

  void _showSaveFileDialog(BuildContext context, List<String> folders) {
    String fileName = '';
    String selectedFolder = folders.isNotEmpty ? folders[0] : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Сохранить файл'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedFolder,
                    items: folders.map((String folder) {
                      return DropdownMenuItem<String>(
                        value: folder,
                        child: Text(folder),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedFolder = value ?? '';
                      });
                    },
                  ),
                  TextField(
                    onChanged: (value) {
                      fileName = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Имя файла',
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Отмена'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (fileName.isNotEmpty) {
                      saveData(
                        calculatedMeasurements,
                        measurementNames,
                        userMeasurements,
                        fileName,
                        selectedFolder,
                      );
                    }
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Загрузить список папок внутри uploads в Firebase Storage
              FirebaseStorage.instance.ref('uploads').listAll().then((result) {
                List<String> folders =
                    result.prefixes.map((e) => e.name).toList();
                _showSaveFileDialog(context, folders);
              }).catchError((error) {
                print('Ошибка при получении списка папок: $error');
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: calculatedMeasurements.length + userMeasurements.length,
        itemBuilder: (context, index) {
          if (index < calculatedMeasurements.length) {
            return ListTile(
              title: Text(measurementNames[index]),
              subtitle: Text(
                'Значение: ${calculatedMeasurements[index].toStringAsFixed(2)} (Вычислено)',
              ),
            );
          } else {
            final userIndex = index - calculatedMeasurements.length;
            return ListTile(
              title: Text(userIndex < measurementNames.length
                  ? measurementNames[userIndex]
                  : 'Неизвестное измерение'),
              subtitle:
                  Text('Значение: ${userMeasurements[userIndex]} (Введено)'),
            );
          }
        },
      ),
    );
  }
}

Future<void> saveData(
  List<double> calculatedMeasurements,
  List<String> measurementNames,
  List<String> userMeasurements,
  String fileName,
  String selectedFolder,
) async {
  try {
    String data = '';

    data += 'Вычеслено: \n\n';
    for (int i = 0; i < calculatedMeasurements.length; i++) {
      data +=
          '${measurementNames[i]}: ${calculatedMeasurements[i].toStringAsFixed(2)} \n\n';
    }
    data += 'Введено: \n\n';
    for (int i = 0; i < userMeasurements.length; i++) {
      final userIndex = calculatedMeasurements.length + i;
      data += '${measurementNames[i]}: ${userMeasurements[i]} \n\n';
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.txt');

    await file.writeAsString(data);

    final storage = FirebaseStorage.instance;
    final filePath =
        'uploads/$selectedFolder/$fileName.txt'; // Используйте выбранную папку

    final ref = storage.ref().child(filePath);
    final task = ref.putFile(file);

    await task.whenComplete(() {
      print('Файл успешно записан');
      file.delete();
    });
  } catch (error) {
    print('Ошибка при загрузке файла: $error');
  }
}
