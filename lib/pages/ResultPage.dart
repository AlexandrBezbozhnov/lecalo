import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;
  final List<String> userMeasurements;

  ResultPage(
    this.calculatedMeasurements,
    this.measurementNames,
    this.userMeasurements,
  );

  void _showFileNameDialog(BuildContext context) {
    String fileName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите имя файла'),
          content: TextField(
            onChanged: (value) {
              fileName = value;
            },
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
                  );
                }
              },
            ),
          ],
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
              _showFileNameDialog(context);
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
              subtitle: Text('Значение: ${userMeasurements[userIndex]} (Введено)'),
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
) async {
  try {
    String data = '';

    for (int i = 0; i < calculatedMeasurements.length; i++) {
      data += '${measurementNames[i]}\n';
      data += 'Значение: ${calculatedMeasurements[i].toStringAsFixed(2)} (Вычислено).\n';
    }

    for (int i = 0; i < userMeasurements.length; i++) {
      final userIndex = calculatedMeasurements.length + i;
      data += '${measurementNames[i]}\n';
      data += 'Значение: ${userMeasurements[i]} (Введено).\n';
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName.txt');

    await file.writeAsString(data);

    final storage = FirebaseStorage.instance;
    final filePath = 'uploads/$fileName.txt';

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