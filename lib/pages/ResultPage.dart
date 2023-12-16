import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;
  final List<String> userMeasurements;
  String selectedClothingType;
  String selectedAgeCategory;

  ResultPage(this.calculatedMeasurements, this.measurementNames,
      this.userMeasurements, this.selectedClothingType, this.selectedAgeCategory);

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
                        selectedAgeCategory,
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
  String selectedAgeCategory,
) async {
  try {
    // Создание текста для файла .txt
    String data = '$selectedClothingType\n\n$selectedAgeCategory\n\nВычеслено: \n\n';
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
      if (selectedAgeCategory == 'Малыш'){
      final code = ''' 
Sub DrawSquareWithDimensions()
Kupalnik
Rucav
DrawCheckSquare
End Sub
 Public Sub AddLine(startX As Double, startY As Double, endX As Double, endY As Double)
 
   Dim startPoint(0 To 2) As Double
   Dim endPoint(0 To 2) As Double
        startPoint(0) = startX
        startPoint(1) = startY
        startPoint(2) = 0

        endPoint(0) = endX
        endPoint(1) = endY
        endPoint(2) = 0

        ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    End Sub
    Public Sub AddLineKri5(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 14) As Double   
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 4
    fitPoints(4) = startY + (endY - startY) / 4
    fitPoints(5) = 0
    fitPoints(6) = startX + (endX - startX) / 2
    fitPoints(7) = startY + (endY - startY) / 2
    fitPoints(8) = 0
    fitPoints(9) = startX + 3 * (endX - startX) / 4
    fitPoints(10) = startY + 3 * (endY - startY) / 4
    fitPoints(11) = 0
    fitPoints(12) = endX
    fitPoints(13) = endY
    fitPoints(14) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri4(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 3
    fitPoints(4) = startY + (endY - startY) / 3
    fitPoints(5) = 0
    fitPoints(6) = startX + 2 * (endX - startX) / 3
    fitPoints(7) = startY + 2 * (endY - startY) / 3
    fitPoints(8) = 0
    fitPoints(9) = endX
    fitPoints(10) = endY
    fitPoints(11) = 0 
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri3(startX As Double, startY As Double, endX As Double, endY As Double)
     Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim midX As Double
    Dim midY As Double
    Dim fitPoints(0 To 8 ) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri2(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX: fitPoints(1) = startY: fitPoints(2) = 0
    fitPoints(3) = endX: fitPoints(4) = endY: fitPoints(5) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
    End Sub
    Public Sub AddLineKri3zad(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 8 ) As Double
    Dim midX As Double
    Dim midY As Double
    startTan(0) = -2: startTan(1) = 0.3: startTan(2) = 0
    endTan(0) = 0.3: endTan(1) = -0.8: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan) 
    End Sub
 Public Sub Rucav()
 Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double
    Dim eighthX As Double: eighthX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
    
    
    Dim standart As Double: standart = 7
    Dim distan As Double: distan = 50
   
    first = 0
    firstX = 0 + distan
    firstY = standart 
    
    second = ${calculatedMeasurements[11].toStringAsFixed(2)} -  standart 
    secondX = 0 + distan
    secondY = secondY - second
    
    AddLine firstX, firstY, secondX, secondY

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    third = 0
    thirdX = 0 + distan
    thirdY = 0
    
    fifth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    sixth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    
    
    fifthX = thirdX - fifth / 2
    sixthX = thirdX + sixth / 2
    
    fifthY = thirdY
    sixthY = thirdY
   
    
    AddLine fifthX, fifthY, sixthX, sixthY
    '-----------------------------------------------------------------------------
        
    seventh = ${calculatedMeasurements[4].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    
    
    seventhX = secondX - seventh / 2
    eighthX = secondX + eighth / 2
    
    seventhY = secondY
    eighthY = secondY
  
    
    AddLine seventhX, seventhY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri5 firstX, firstY, fifthX, fifthY
    AddLineKri5 firstX, firstY, sixthX, sixthY
    AddLineKri5 fifthX, fifthY, seventhX, seventhY
    AddLineKri5 sixthX, sixthY, eighthX, eighthY
    
 End Sub
Public Sub Kupalnik()
  Dim obj As AcadObject
    For Each obj In ThisDrawing.ModelSpace
        obj.Delete
    Next obj
    
    Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double: fifth = 15
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double: seventh = 22
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double: eighth = 17
    Dim eighthX As Double: eighthX = 0
    
    Dim ninth, ninthY As Double: ninth = 20
    Dim ninthX As Double: ninthX = 0
    
    Dim tenth, tenthY As Double: tenth = 23
    Dim tenthX As Double: tenthX = 0
    
    Dim eleventh, eleventhY As Double: eleventh = 10
    Dim eleventhX As Double: eleventhX = 0
    
    Dim twelfth, twelfthY As Double: twelfth = 13
    Dim twelfthX As Double: twelfthX = 0
    
    Dim thirteen, thirteenY As Double: thirteen = 5
    Dim thirteenX As Double: thirteenX = 0
    
    Dim fourteen, fourteenY As Double
    Dim fourteenX As Double: fourteenX = 0
    
    Dim fifteen, fifteenY As Double: fifteen = 10
    Dim fifteenX As Double: fifteenX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
      
    first = 0
    firstX = 0
    firstY = 0
    
    second = ${calculatedMeasurements[12].toStringAsFixed(2)}
    secondX = 0
    secondY = secondY - second
    AddLine firstX, firstY, secondX, secondY
    
    location1(0) = firstX - 15#: location1(1) = 0#: location1(2) = 0#

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    location1(0) = 0#: location1(1) = 0#: location1(2) = 0#
    
    twelfth = 5
    sixth = ${calculatedMeasurements[0].toStringAsFixed(2)}
    seventh = ${calculatedMeasurements[6].toStringAsFixed(2)}
    
    
    twelfthX = 0
    twelfthY = twelfth * -1
    
    sixthX = sixth
    sixthY = 0
    
    AddLineKri2 twelfthX, twelfthY, sixthX, sixthY
    AddLineKri2 twelfthX, twelfthY - 3, sixthX, sixthY
    
    seventhX = seventh
    seventhY = -2 'СТАНДАРТ
    
    AddLine seventhX, seventhY, sixthX, sixthY
    
    
    
   '-----------------------------------------------------------------------------
   
   fifth = ${calculatedMeasurements[9].toStringAsFixed(2)}
   ninth = ${calculatedMeasurements[1].toStringAsFixed(2)}
   
   fifthX = 0
   fifthY = fifth * -1
   
   ninthX = ninth
   ninthY = fifthY
   location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
   AddLine fifthX, fifthY, ninthX, ninthY
   
   '----------------------------------------------------------------------------
    
    fifteen = fifth / 2
    eleventh = ${calculatedMeasurements[7].toStringAsFixed(2)}
    
    
    fifteenX = 0
    fifteenY = fifteen * -1
    
    eleventhX = eleventh
    eleventhY = fifteenY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
    AddLine fifteenX, fifteenY, eleventhX, eleventhY
    '-----------------------------------------------------------------------------
    
    third = ${calculatedMeasurements[14].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[2].toStringAsFixed(2)}
    
    
    thirdX = 0
    thirdY = third * -1
    
    eighthX = eighth
    eighthY = thirdY
    
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
     AddLine thirdX, thirdY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    fourth = ${calculatedMeasurements[10].toStringAsFixed(2)}
    tenth = ${calculatedMeasurements[3].toStringAsFixed(2)}
    
    fourthX = 0
    fourthY = fourth * -1
    
    tenthX = tenth
    tenthY = fourthY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine tenthX, tenthY, fourthX, fourthY
    '-----------------------------------------------------------------------------
    
    thirteen = 3 'СТРАНДАРТ тр
    
    thirteenY = secondY
    thirteenX = thirteen
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine thirteenX, thirteenY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri2 seventhX, seventhY, eleventhX, eleventhY
    AddLineKri2 eleventhX, eleventhY, ninthX, ninthY
    AddLineKri2 ninthX, ninthY, eighthX, eighthY
    AddLineKri2 eighthX, eighthY, tenthX, tenthY
    AddLineKri5 tenthX, tenthY, thirteenX, thirteenY
    AddLineKri3zad tenthX, tenthY, thirteenX, thirteenY
    
End Sub

Sub DrawCheckSquare()
    Dim checkSquareSize As Double
    checkSquareSize = 3

    Dim topLeftX As Double: topLeftX = 5 
    Dim topLeftY As Double: topLeftY = -5 
    Dim bottomRightX As Double: bottomRightX = topLeftX + checkSquareSize
    Dim bottomRightY As Double: bottomRightY = topLeftY - checkSquareSize

    AddLine topLeftX, topLeftY, topLeftX, bottomRightY
    AddLine topLeftX, bottomRightY, bottomRightX, bottomRightY
    AddLine bottomRightX, bottomRightY, bottomRightX, topLeftY
    AddLine bottomRightX, topLeftY, topLeftX, topLeftY
End Sub
 ''';
       await fileBas.writeAsString(code);
      }
      else if (selectedAgeCategory == 'Девочка'){
      final code = ''' 
Sub DrawSquareWithDimensions()
Kupalnik
Rucav
DrawCheckSquare
End Sub
 Public Sub AddLine(startX As Double, startY As Double, endX As Double, endY As Double)
 
   Dim startPoint(0 To 2) As Double
   Dim endPoint(0 To 2) As Double
        startPoint(0) = startX
        startPoint(1) = startY
        startPoint(2) = 0

        endPoint(0) = endX
        endPoint(1) = endY
        endPoint(2) = 0

        ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    End Sub
    Public Sub AddLineKri5(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 14) As Double   
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 4
    fitPoints(4) = startY + (endY - startY) / 4
    fitPoints(5) = 0
    fitPoints(6) = startX + (endX - startX) / 2
    fitPoints(7) = startY + (endY - startY) / 2
    fitPoints(8) = 0
    fitPoints(9) = startX + 3 * (endX - startX) / 4
    fitPoints(10) = startY + 3 * (endY - startY) / 4
    fitPoints(11) = 0
    fitPoints(12) = endX
    fitPoints(13) = endY
    fitPoints(14) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri4(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 3
    fitPoints(4) = startY + (endY - startY) / 3
    fitPoints(5) = 0
    fitPoints(6) = startX + 2 * (endX - startX) / 3
    fitPoints(7) = startY + 2 * (endY - startY) / 3
    fitPoints(8) = 0
    fitPoints(9) = endX
    fitPoints(10) = endY
    fitPoints(11) = 0 
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri3(startX As Double, startY As Double, endX As Double, endY As Double)
     Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim midX As Double
    Dim midY As Double
    Dim fitPoints(0 To 8 ) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri2(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX: fitPoints(1) = startY: fitPoints(2) = 0
    fitPoints(3) = endX: fitPoints(4) = endY: fitPoints(5) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
    End Sub
    Public Sub AddLineKri3zad(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 8 ) As Double
    Dim midX As Double
    Dim midY As Double
    startTan(0) = -2: startTan(1) = 0.3: startTan(2) = 0
    endTan(0) = 0.3: endTan(1) = -0.8: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan) 
    End Sub
 Public Sub Rucav()
 Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double
    Dim eighthX As Double: eighthX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
    
    
    Dim standart As Double: standart = 9
    Dim distan As Double: distan = 50
   
    first = 0
    firstX = 0 + distan
    firstY = standart 
    
    second = ${calculatedMeasurements[11].toStringAsFixed(2)} -  standart 
    secondX = 0 + distan
    secondY = secondY - second
    
    AddLine firstX, firstY, secondX, secondY

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    third = 0
    thirdX = 0 + distan
    thirdY = 0
    
    fifth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    sixth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    
    
    fifthX = thirdX - fifth / 2
    sixthX = thirdX + sixth / 2
    
    fifthY = thirdY
    sixthY = thirdY
   
    
    AddLine fifthX, fifthY, sixthX, sixthY
    '-----------------------------------------------------------------------------
        
    seventh = ${calculatedMeasurements[22].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    
    
    seventhX = secondX - seventh / 2
    eighthX = secondX + eighth / 2
    
    seventhY = secondY
    eighthY = secondY
  
    
    AddLine seventhX, seventhY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri5 firstX, firstY, fifthX, fifthY
    AddLineKri5 firstX, firstY, sixthX, sixthY
    AddLineKri5 fifthX, fifthY, seventhX, seventhY
    AddLineKri5 sixthX, sixthY, eighthX, eighthY
    
 End Sub
Public Sub Kupalnik()
  Dim obj As AcadObject
    For Each obj In ThisDrawing.ModelSpace
        obj.Delete
    Next obj
    
    Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double: fifth = 15
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double: seventh = 22
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double: eighth = 17
    Dim eighthX As Double: eighthX = 0
    
    Dim ninth, ninthY As Double: ninth = 20
    Dim ninthX As Double: ninthX = 0
    
    Dim tenth, tenthY As Double: tenth = 23
    Dim tenthX As Double: tenthX = 0
    
    Dim eleventh, eleventhY As Double: eleventh = 10
    Dim eleventhX As Double: eleventhX = 0
    
    Dim twelfth, twelfthY As Double: twelfth = 13
    Dim twelfthX As Double: twelfthX = 0
    
    Dim thirteen, thirteenY As Double: thirteen = 5
    Dim thirteenX As Double: thirteenX = 0
    
    Dim fourteen, fourteenY As Double
    Dim fourteenX As Double: fourteenX = 0
    
    Dim fifteen, fifteenY As Double: fifteen = 10
    Dim fifteenX As Double: fifteenX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
      
    first = 0
    firstX = 0
    firstY = 0
    
    second = ${calculatedMeasurements[12].toStringAsFixed(2)}
    secondX = 0
    secondY = secondY - second
    AddLine firstX, firstY, secondX, secondY
    
    location1(0) = firstX - 15#: location1(1) = 0#: location1(2) = 0#

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    location1(0) = 0#: location1(1) = 0#: location1(2) = 0#
    
    twelfth = 5
    sixth = ${calculatedMeasurements[0].toStringAsFixed(2)}
    seventh = ${calculatedMeasurements[6].toStringAsFixed(2)}
    
    
    twelfthX = 0
    twelfthY = twelfth * -1
    
    sixthX = sixth
    sixthY = 0
    
    AddLineKri2 twelfthX, twelfthY, sixthX, sixthY
    AddLineKri2 twelfthX, twelfthY - 3, sixthX, sixthY
    
    seventhX = seventh
    seventhY = -3 'СТАНДАРТ
    
    AddLine seventhX, seventhY, sixthX, sixthY
    
    
    
   '-----------------------------------------------------------------------------
   
   fifth = ${calculatedMeasurements[9].toStringAsFixed(2)}
   ninth = ${calculatedMeasurements[1].toStringAsFixed(2)}
   
   fifthX = 0
   fifthY = fifth * -1
   
   ninthX = ninth
   ninthY = fifthY
   location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
   AddLine fifthX, fifthY, ninthX, ninthY
   
   '----------------------------------------------------------------------------
    
    fifteen = fifth / 2
    eleventh = ${calculatedMeasurements[7].toStringAsFixed(2)}
    
    
    fifteenX = 0
    fifteenY = fifteen * -1
    
    eleventhX = eleventh
    eleventhY = fifteenY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
    AddLine fifteenX, fifteenY, eleventhX, eleventhY
    '-----------------------------------------------------------------------------
    
    third = ${calculatedMeasurements[14].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[2].toStringAsFixed(2)}
    
    
    thirdX = 0
    thirdY = third * -1
    
    eighthX = eighth
    eighthY = thirdY
    
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
     AddLine thirdX, thirdY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    fourth = ${calculatedMeasurements[10].toStringAsFixed(2)}
    tenth = ${calculatedMeasurements[3].toStringAsFixed(2)}
    
    fourthX = 0
    fourthY = fourth * -1
    
    tenthX = tenth
    tenthY = fourthY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine tenthX, tenthY, fourthX, fourthY
    '-----------------------------------------------------------------------------
    
    thirteen = 4 'СТРАНДАРТ тр
    
    thirteenY = secondY
    thirteenX = thirteen
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine thirteenX, thirteenY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri2 seventhX, seventhY, eleventhX, eleventhY
    AddLineKri2 eleventhX, eleventhY, ninthX, ninthY
    AddLineKri2 ninthX, ninthY, eighthX, eighthY
    AddLineKri2 eighthX, eighthY, tenthX, tenthY
    AddLineKri5 tenthX, tenthY, thirteenX, thirteenY
    AddLineKri3zad tenthX, tenthY, thirteenX, thirteenY
    
End Sub

Sub DrawCheckSquare()
    Dim checkSquareSize As Double
    checkSquareSize = 3

    Dim topLeftX As Double: topLeftX = 5 
    Dim topLeftY As Double: topLeftY = -5 
    Dim bottomRightX As Double: bottomRightX = topLeftX + checkSquareSize
    Dim bottomRightY As Double: bottomRightY = topLeftY - checkSquareSize

    AddLine topLeftX, topLeftY, topLeftX, bottomRightY
    AddLine topLeftX, bottomRightY, bottomRightX, bottomRightY
    AddLine bottomRightX, bottomRightY, bottomRightX, topLeftY
    AddLine bottomRightX, topLeftY, topLeftX, topLeftY
End Sub
 ''';
       await fileBas.writeAsString(code);
      }
      else if (selectedAgeCategory == 'Юниорка'){
      final code = ''' 
Sub DrawSquareWithDimensions()
Kupalnik
Rucav
DrawCheckSquare
End Sub
 Public Sub AddLine(startX As Double, startY As Double, endX As Double, endY As Double)
 
   Dim startPoint(0 To 2) As Double
   Dim endPoint(0 To 2) As Double
        startPoint(0) = startX
        startPoint(1) = startY
        startPoint(2) = 0

        endPoint(0) = endX
        endPoint(1) = endY
        endPoint(2) = 0

        ThisDrawing.ModelSpace.AddLine startPoint, endPoint
    End Sub
    Public Sub AddLineKri5(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 14) As Double   
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 4
    fitPoints(4) = startY + (endY - startY) / 4
    fitPoints(5) = 0
    fitPoints(6) = startX + (endX - startX) / 2
    fitPoints(7) = startY + (endY - startY) / 2
    fitPoints(8) = 0
    fitPoints(9) = startX + 3 * (endX - startX) / 4
    fitPoints(10) = startY + 3 * (endY - startY) / 4
    fitPoints(11) = 0
    fitPoints(12) = endX
    fitPoints(13) = endY
    fitPoints(14) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri4(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0  
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0   
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = startX + (endX - startX) / 3
    fitPoints(4) = startY + (endY - startY) / 3
    fitPoints(5) = 0
    fitPoints(6) = startX + 2 * (endX - startX) / 3
    fitPoints(7) = startY + 2 * (endY - startY) / 3
    fitPoints(8) = 0
    fitPoints(9) = endX
    fitPoints(10) = endY
    fitPoints(11) = 0 
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri3(startX As Double, startY As Double, endX As Double, endY As Double)
     Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim midX As Double
    Dim midY As Double
    Dim fitPoints(0 To 8) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
End Sub
Public Sub AddLineKri2(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 5) As Double
    startTan(0) = 0: startTan(1) = 0: startTan(2) = 0
    endTan(0) = 0: endTan(1) = 0: endTan(2) = 0
    fitPoints(0) = startX: fitPoints(1) = startY: fitPoints(2) = 0
    fitPoints(3) = endX: fitPoints(4) = endY: fitPoints(5) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan)
    End Sub
    Public Sub AddLineKri3zad(startX As Double, startY As Double, endX As Double, endY As Double)
    Dim splineObj As AcadSpline
    Dim startTan(0 To 2) As Double
    Dim endTan(0 To 2) As Double
    Dim fitPoints(0 To 8) As Double
    Dim midX As Double
    Dim midY As Double
    startTan(0) = -2: startTan(1) = 0.3: startTan(2) = 0
    endTan(0) = 0.3: endTan(1) = -0.8: endTan(2) = 0
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    fitPoints(0) = startX
    fitPoints(1) = startY
    fitPoints(2) = 0
    fitPoints(3) = midX
    fitPoints(4) = midY
    fitPoints(5) = 0
    fitPoints(6) = endX
    fitPoints(7) = endY
    fitPoints(8) = 0
    Set splineObj = ThisDrawing.ModelSpace.AddSpline(fitPoints, startTan, endTan) 
    End Sub
 Public Sub Rucav()
 Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double
    Dim eighthX As Double: eighthX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
    
    
    Dim standart As Double: standart = 11
    Dim distan As Double: distan = 50
   
    first = 0
    firstX = 0 + distan
    firstY = standart 
    
    second = ${calculatedMeasurements[11].toStringAsFixed(2)} -  standart 
    secondX = 0 + distan
    secondY = secondY - second
    
    AddLine firstX, firstY, secondX, secondY

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    third = 0
    thirdX = 0 + distan
    thirdY = 0
    
    fifth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    sixth = ${calculatedMeasurements[4].toStringAsFixed(2)}
    
    
    fifthX = thirdX - fifth / 2
    sixthX = thirdX + sixth / 2
    
    fifthY = thirdY
    sixthY = thirdY
   
    
    AddLine fifthX, fifthY, sixthX, sixthY
    '-----------------------------------------------------------------------------
        
    seventh = ${calculatedMeasurements[22].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[22].toStringAsFixed(2)}
    
    
    seventhX = secondX - seventh / 2
    eighthX = secondX + eighth / 2
    
    seventhY = secondY
    eighthY = secondY
  
    
    AddLine seventhX, seventhY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri5 firstX, firstY, fifthX, fifthY
    AddLineKri5 firstX, firstY, sixthX, sixthY
    AddLineKri5 fifthX, fifthY, seventhX, seventhY
    AddLineKri5 sixthX, sixthY, eighthX, eighthY
    
 End Sub
Public Sub Kupalnik()
  Dim obj As AcadObject
    For Each obj In ThisDrawing.ModelSpace
        obj.Delete
    Next obj
    
    Dim first, firstY As Double
    Dim firstX As Double: firstX = 0
    
    Dim second, secondY As Double
    Dim secondX As Double: secondX = 0
    
    Dim third, thirdY As Double: third = 20
    Dim thirdX As Double: thirdX = 0
    
    Dim fourth, fourthY As Double: fourth = 25
    Dim fourthX As Double: fourthX = 0
    
    Dim fifth, fifthY As Double: fifth = 15
    Dim fifthX As Double: fifthX = 0
    
    Dim sixth, sixthY As Double
    Dim sixthX As Double: sixthX = 0
    
    Dim seventh, seventhY As Double: seventh = 22
    Dim seventhX As Double: seventhX = 0
    
    Dim eighth, eighthY As Double: eighth = 17
    Dim eighthX As Double: eighthX = 0
    
    Dim ninth, ninthY As Double: ninth = 20
    Dim ninthX As Double: ninthX = 0
    
    Dim tenth, tenthY As Double: tenth = 23
    Dim tenthX As Double: tenthX = 0
    
    Dim eleventh, eleventhY As Double: eleventh = 10
    Dim eleventhX As Double: eleventhX = 0
    
    Dim twelfth, twelfthY As Double: twelfth = 13
    Dim twelfthX As Double: twelfthX = 0
    
    Dim thirteen, thirteenY As Double: thirteen = 5
    Dim thirteenX As Double: thirteenX = 0
    
    Dim fourteen, fourteenY As Double
    Dim fourteenX As Double: fourteenX = 0
    
    Dim fifteen, fifteenY As Double: fifteen = 10
    Dim fifteenX As Double: fifteenX = 0
    
    Dim location1(0 To 2) As Double
    Dim dimLine1 As AcadDimAligned
    
    Dim startPoint(0 To 2) As Double
    Dim endPoint(0 To 2) As Double
      
    first = 0
    firstX = 0
    firstY = 0
    
    second = ${calculatedMeasurements[12].toStringAsFixed(2)}
    secondX = 0
    secondY = secondY - second
    AddLine firstX, firstY, secondX, secondY
    
    location1(0) = firstX - 15#: location1(1) = 0#: location1(2) = 0#

    AddLine firstX, firstY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    location1(0) = 0#: location1(1) = 0#: location1(2) = 0#
    
    twelfth = 5
    sixth = ${calculatedMeasurements[0].toStringAsFixed(2)}
    seventh = ${calculatedMeasurements[6].toStringAsFixed(2)}
    
    
    twelfthX = 0
    twelfthY = twelfth * -1
    
    sixthX = sixth
    sixthY = 0
    
    AddLineKri2 twelfthX, twelfthY, sixthX, sixthY
    AddLineKri2 twelfthX, twelfthY - 3, sixthX, sixthY
    
    seventhX = seventh
    seventhY = -3 'СТАНДАРТ
    
    AddLine seventhX, seventhY, sixthX, sixthY
    
    
    
   '-----------------------------------------------------------------------------
   
   fifth = ${calculatedMeasurements[9].toStringAsFixed(2)}
   ninth = ${calculatedMeasurements[1].toStringAsFixed(2)}
   
   fifthX = 0
   fifthY = fifth * -1
   
   ninthX = ninth
   ninthY = fifthY
   location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
   AddLine fifthX, fifthY, ninthX, ninthY
   
   '----------------------------------------------------------------------------
    
    fifteen = fifth / 2
    eleventh = ${calculatedMeasurements[7].toStringAsFixed(2)}
    
    
    fifteenX = 0
    fifteenY = fifteen * -1
    
    eleventhX = eleventh
    eleventhY = fifteenY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    
    AddLine fifteenX, fifteenY, eleventhX, eleventhY
    '-----------------------------------------------------------------------------
    
    third = ${calculatedMeasurements[14].toStringAsFixed(2)}
    eighth = ${calculatedMeasurements[2].toStringAsFixed(2)}
    
    
    thirdX = 0
    thirdY = third * -1
    
    eighthX = eighth
    eighthY = thirdY
    
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
     AddLine thirdX, thirdY, eighthX, eighthY
    '-----------------------------------------------------------------------------
    
    fourth = ${calculatedMeasurements[10].toStringAsFixed(2)}
    tenth = ${calculatedMeasurements[3].toStringAsFixed(2)}
    
    fourthX = 0
    fourthY = fourth * -1
    
    tenthX = tenth
    tenthY = fourthY
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine tenthX, tenthY, fourthX, fourthY
    '-----------------------------------------------------------------------------
    
    thirteen = 5 'СТРАНДАРТ тр
    
    thirteenY = secondY
    thirteenX = thirteen
    
    location1(0) = 0: location1(1) = 0#: location1(2) = 0#
    AddLine thirteenX, thirteenY, secondX, secondY
    '-----------------------------------------------------------------------------
    
    
    AddLineKri2 seventhX, seventhY, eleventhX, eleventhY
    AddLineKri2 eleventhX, eleventhY, ninthX, ninthY
    AddLineKri2 ninthX, ninthY, eighthX, eighthY
    AddLineKri2 eighthX, eighthY, tenthX, tenthY
    AddLineKri5 tenthX, tenthY, thirteenX, thirteenY
    AddLineKri3zad tenthX, tenthY, thirteenX, thirteenY
    
End Sub

Sub DrawCheckSquare()
    Dim checkSquareSize As Double
    checkSquareSize = 3

    Dim topLeftX As Double: topLeftX = 5 
    Dim topLeftY As Double: topLeftY = -5 
    Dim bottomRightX As Double: bottomRightX = topLeftX + checkSquareSize
    Dim bottomRightY As Double: bottomRightY = topLeftY - checkSquareSize

    AddLine topLeftX, topLeftY, topLeftX, bottomRightY
    AddLine topLeftX, bottomRightY, bottomRightX, bottomRightY
    AddLine bottomRightX, bottomRightY, bottomRightX, topLeftY
    AddLine bottomRightX, topLeftY, topLeftX, topLeftY
End Sub
 ''';
       await fileBas.writeAsString(code);
      }
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
