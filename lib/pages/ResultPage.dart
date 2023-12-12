import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'mainPage.dart';
import 'dart:async';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;
  final List<String> userMeasurements;
  String selectedClothingType;

  ResultPage(this.calculatedMeasurements, this.measurementNames,
      this.userMeasurements, this.selectedClothingType);

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
                      fileName = '$value $selectedClothingType';
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
                        selectedClothingType,
                      );
                    }
                    Navigator.pushReplacementNamed(context, '/');
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
        title: Text('Результаты',
          textAlign: TextAlign.center,
        ),
        centerTitle: true, 
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
                '${calculatedMeasurements[index].toStringAsFixed(2)} (Вычислено)',
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
  String selectedClothingType,
) async {
  try {
    // Создание текста для файла .txt
    String data = '$selectedClothingType \n\nВычеслено: \n\n';
    for (int i = 0; i < calculatedMeasurements.length; i++) {
      data +=
          '${measurementNames[i]}: ${calculatedMeasurements[i].toStringAsFixed(2)} \n\n';
    }
    data += 'Введено: \n\n';
    for (int i = 0; i < userMeasurements.length; i++) {
      final userIndex = calculatedMeasurements.length + i;
      data += '${measurementNames[i]}: ${userMeasurements[i]} \n\n';
    }

    // Запись данных в файл .txt
    final directory = await getApplicationDocumentsDirectory();
    final fileTxt = File('${directory.path}/$fileName.txt');
    await fileTxt.writeAsString(data);

    // Создание текста для файла .bas
    final fileBas = File('${directory.path}/$fileName.bas');
    if (selectedClothingType == 'Лосины') {
      final code = '''
Sub DrawSquareWithDimensions()
  Dim obj As AcadObject
    For Each obj In ThisDrawing.ModelSpace
        obj.Delete
    Next obj
    Dim sideLength As Double
    
    Dim first, firstX, firstY As Double
    Dim second, secondX, secondY As Double
    Dim third, thirdX, thirdY As Double

    Dim fourth, fourthX, fourthY As Double
    Dim fifth, fifthX, fifthY As Double
    Dim sixth, sixthX, sixthY As Double

    Dim seventh, seventhX, seventhY As Double
    Dim eighth, eighthX, eighthY As Double
    Dim ninth, ninthX, ninthY As Double

    Dim tenth, tenthX, tenthY As Double
    Dim eleventh, eleventhX, eleventhY As Double
    Dim twelfth, twelfthX, twelfthY As Double

    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
    
    
    
    first = 0
    firstX = 0
    firstY = 0
    
    second = ${calculatedMeasurements[6].toStringAsFixed(2)}
    secondX = 0
    secondY = secondY - second
       

    ' Задайте начальную точку
    startPoint(0) = firstX
    startPoint(1) = firstY
    startPoint(2) = 0

    ' Рисование первой линии (вправо)
    endPoint(0) = secondX
    endPoint(1) = secondY
    endPoint(2) = 0
    ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    location1(0) = -10#: location1(1) = 0#: location1(2) = 0#
    'Set dimLine1 = ThisDrawing.ModelSpace.AddDimAligned(startPoint, endPoint, location1)
    'dimLine1.StyleName = "Standard"
    '-----------------------------------------------------------------------------
    first = 0
    firstX = 0
    firstY = firstY - first
    
    
    eleventh = ${calculatedMeasurements[0].toStringAsFixed(2)}
    twelfth = ${calculatedMeasurements[0].toStringAsFixed(2)}
    
    eleventhX = firstX - eleventh / 2
    twelfthX = firstX + twelfth / 2
    
    eleventhY = firstY + 2
    twelfthY = firstY
    
    
    startPoint(0) = eleventhX
    startPoint(1) = eleventhY
    startPoint(2) = 0
    
    endPoint(0) = twelfthX
    endPoint(1) = twelfthY
    endPoint(2) = 0
    
    ThisDrawing.ModelSpace.AddLine startPoint, endPoint

    location1(0) = -10#: location1(1) = 0#: location1(2) = 0#
    'Set dimLine1 = ThisDrawing.ModelSpace.AddDimAligned(startPoint, endPoint, location1)
    'dimLine1.StyleName = "Standard"
    '-----------------------------------------------------------------------------
    third = ${calculatedMeasurements[8].toStringAsFixed(2)}
    thirdX = 0
    thirdY = firstY - third
    
    
    ninth = ${calculatedMeasurements[2].toStringAsFixed(2)} + 2
    tenth = ${calculatedMeasurements[2].toStringAsFixed(2)} - 2
    
    ninthX = thirdX - ninth / 2
    tenthX = thirdX + tenth / 2
    
    ninthY = thirdY
    tenthY = thirdY
    
    
    startPoint(0) = ninthX
    startPoint(1) = ninthY
    startPoint(2) = 0
    
    endPoint(0) = tenthX
    endPoint(1) = tenthY
    endPoint(2) = 0
    
    ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    location1(0) = -10#: location1(1) = 0#: location1(2) = 0#
   ' Set dimLine1 = ThisDrawing.ModelSpace.AddDimAligned(startPoint, endPoint, location1)
    'dimLine1.StyleName = "Standard"
    '-----------------------------------------------------------------------------
    
     fourth = ${calculatedMeasurements[7].toStringAsFixed(2)}
    fourthX = 0
    fourthY = fourthY - fourth
    
    seventh = ${calculatedMeasurements[3].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[3].toStringAsFixed(2)}
    
    
    seventhX = fourthX - seventh / 2
    eighthX = eighthX + eighth / 2
    
    seventhY = fourthY
    eighthY = fourthY
    
    
    startPoint(0) = seventhX
    startPoint(1) = seventhY
    startPoint(2) = 0
    
    endPoint(0) = eighthX
    endPoint(1) = eighthY
    endPoint(2) = 0
    
    ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    
    location1(0) = -10#: location1(1) = 0#: location1(2) = 0#
    'Set dimLine1 = ThisDrawing.ModelSpace.AddDimAligned(startPoint, endPoint, location1)
    'dimLine1.StyleName = "Standard"
    '-----------------------------------------------------------------------------
    
    
    
    fifth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    sixth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    
    
    fifthX = fifthX - fifth / 2
    sixthX = sixthX + sixth / 2
    
    fifthY = secondY
    sixthY = secondY
    
    
    startPoint(0) = fifthX
    startPoint(1) = fifthY
    startPoint(2) = 0
    
    endPoint(0) = sixthX
    endPoint(1) = sixthY
    endPoint(2) = 0
''';
      await fileBas.writeAsString(code);
    } else if (selectedClothingType == 'Комбинезон') {
      final code = ''' Комбинезон ''';
      await fileBas.writeAsString(code);
    } else if (selectedClothingType == 'Купальник') {
      final code = ''' Купальник ''';
      await fileBas.writeAsString(code);
    }

    // Отправка файлов на Firebase Storage
    final storage = FirebaseStorage.instance;
    final filePathTxt = 'uploads/$selectedFolder/$fileName.txt';
    final filePathBas = 'uploads/$selectedFolder/$fileName.bas';

    final refTxt = storage.ref().child(filePathTxt);
    final taskTxt = refTxt.putFile(fileTxt);
    await taskTxt.whenComplete(() {
      print('Файл .txt успешно записан');
      fileTxt.delete();
    });

    final refBas = storage.ref().child(filePathBas);
    final taskBas = refBas.putFile(fileBas);
    await taskBas.whenComplete(() {
      print('Файл .bas успешно записан');
      fileBas.delete();
    });
  } catch (error) {
    print('Ошибка при загрузке файлов: $error');
  }
}
