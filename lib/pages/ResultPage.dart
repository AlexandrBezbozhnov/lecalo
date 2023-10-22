import 'package:flutter/material.dart';
import 'saveAndUploadData.dart';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;
  final List<String> userMeasurements;

  ResultPage(this.calculatedMeasurements, this.measurementNames, this.userMeasurements);

  void _showFileNameDialog(BuildContext context) {
    String fileName = ''; // Переменная для хранения имени файла

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите имя файла'),
          content: TextField(
            onChanged: (value) {
              fileName = value; // Сохраняем введенное имя файла
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
                  // Если имя файла не пустое, вызываем функцию сохранения
                  saveAndUploadData(calculatedMeasurements, measurementNames, userMeasurements, fileName);
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
              _showFileNameDialog(context); // Открываем диалоговое окно для ввода имени файла
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: calculatedMeasurements.length + userMeasurements.length,
        itemBuilder: (context, index) {
          // Ваш текущий код остается без изменений
          if (index < calculatedMeasurements.length) {
            return ListTile(
              title: Text(measurementNames[index]),
              subtitle: Text(
                  'Значение: ${calculatedMeasurements[index].toStringAsFixed(2)} (Вычислено)'),
            );
          } else {
            final userIndex = index - calculatedMeasurements.length;
            return ListTile(
              title: Text(measurementNames[userIndex]),
              subtitle:
                  Text('Значение: ${userMeasurements[userIndex]} (Введено)'),
            );
          }
        },
      ),
    );
  }
}