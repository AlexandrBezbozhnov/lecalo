import 'package:flutter/material.dart';
import 'resultPage.dart';

class CreatePatternPage extends StatefulWidget {
  @override
  _CreatePatternPageState createState() => _CreatePatternPageState();
}

class _CreatePatternPageState extends State<CreatePatternPage> {
  final List<String> clothingTypes = ['Комбинезон', 'Купальник', 'Лосины'];
  final List<String> ageCategories = ['Малыш', 'Девочка', 'Юниорка'];
  final List<String> sleeveTypes = ['Короткий', 'Длинный', 'Без рукавов'];

  String selectedClothingType = 'Комбинезон';
  String selectedAgeCategory = 'Малыш';
  String selectedSleeveType = 'Короткий';

  Map<String, List<String>> measurementNames = {
    'Комбинезон': [
      'Обхват шеи',
      'Обхват груди',
      'Обхват талии',
      'Обхват бедер',
      'Обхват бедра в паху',
      'Обхват колена',
      'Обхват щиколотки',
      'Обхват подъема стопы',
      'Обхват руки под мышкой',
      'Длина плеча',
      'Ширина плеч (от косточки до косточки)',
      'Ширина груди',
      'Ширина спины',
      'Высота от талии до подмышек',
      'Длина от талии до пола',
      'Длина от талии до колена',
      'Длина рукава',
      'Дуга',
      'Высота сидения',
      'Полудуга',
      'Длина талии переда',
      'Длина талии спинки',
    ],
    'Купальник': [
      'Обхват шеи',
      'Обхват груди',
      'Обхват талии',
      'Обхват бедер',
      'Обхват руки под мышкой',
      'Длина плеча',
      'Ширина плеч (от косточки до косточки)',
      'Ширина груди',
      'Ширина спины',
      'Высота от талии до подмышек',
      'Длина трусов по боку',
      'Длина рукава',
      'Дуга',
      'Полудуга',
      'Попа 1',
      'Попа 2',
      'Попа 3',
      'Перед 1',
      'Перед 2',
      'Перед 3',
      'Длина талии переда',
      'Длина талии спинки',
    ],
    'Лосины': [
      'Обхват талии',
      'Обхват бедер',
      'Обхват бедра в паху',
      'Обхват колена',
      'Обхват щиколотки',
      'Обхват подъема стопы',
      'Длина от талии до пола',
      'Длина от талии до колена',
      'Высота сидения',
      'Полудуга',
    ],
  };

  List<String> measurements = [];

  void _handleMeasurementChange(int index, String value) {
    if (index >= 0 && index < measurementNames[selectedClothingType]!.length) {
      setState(() {
        measurements[index] = value;
      });
    }
  }

  List<double> calculateMeasurements() {
    List<double> calculatedMeasurements = [];

    if (selectedClothingType == 'Комбинезон') {
      double adjustment = 0.0;

      if (selectedAgeCategory == 'Малыш') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 4:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 5:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 6:
              calculatedMeasurements.add(value / 2);
              break;
            case 7:
              calculatedMeasurements.add(value / 2);
              break;
            case 8:
              calculatedMeasurements.add(value - 1);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 11:
              calculatedMeasurements.add(value - 1);
              break;
            case 12:
              calculatedMeasurements.add(value - 1);
              break;
            case 13:
              calculatedMeasurements.add(value - 1);
              break;
            case 14:
              calculatedMeasurements.add(value - 3);
              break;
            case 15:
              calculatedMeasurements.add(value - 2);
              break;
            case 16:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 17:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 18:
              calculatedMeasurements.add(value - 1);
              break;
            case 19:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 20:
              calculatedMeasurements.add(value - 1);
              break;
            case 21:
              calculatedMeasurements.add(value - 1);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Девочка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 4:
              calculatedMeasurements.add((value - 4) / 2);
              break;
            case 5:
              calculatedMeasurements.add((value - 4) / 2);
              break;
            case 6:
              calculatedMeasurements.add(value / 2);
              break;
            case 7:
              calculatedMeasurements.add(value / 2);
              break;
            case 8:
              calculatedMeasurements.add(value - 1);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 11:
              calculatedMeasurements.add(value - 1);
              break;
            case 12:
              calculatedMeasurements.add(value - 1);
              break;
            case 13:
              calculatedMeasurements.add(value - 1);
              break;
            case 14:
              calculatedMeasurements.add(value - 3);
              break;
            case 15:
              calculatedMeasurements.add(value - 2);
              break;
            case 16:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 17:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 18:
              calculatedMeasurements.add(value - 1);
              break;
            case 19:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 20:
              calculatedMeasurements.add(value - 1);
              break;
            case 21:
              calculatedMeasurements.add(value - 1);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Юниорка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 4:
              calculatedMeasurements.add((value - 5) / 2);
              break;
            case 5:
              calculatedMeasurements.add((value - 5) / 2);
              break;
            case 6:
              calculatedMeasurements.add(value / 2);
              break;
            case 7:
              calculatedMeasurements.add(value / 2);
              break;
            case 8:
              calculatedMeasurements.add(value - 1);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 11:
              calculatedMeasurements.add(value - 1);
              break;
            case 12:
              calculatedMeasurements.add(value - 1);
              break;
            case 13:
              calculatedMeasurements.add(value - 1);
              break;
            case 14:
              calculatedMeasurements.add(value - 3);
              break;
            case 15:
              calculatedMeasurements.add(value - 2);
              break;
            case 16:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 17:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 18:
              calculatedMeasurements.add(value - 1);
              break;
            case 19:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 20:
              calculatedMeasurements.add(value - 1);
              break;
            case 21:
              calculatedMeasurements.add(value - 1);
              break;
          }
        }
      }
    } else if (selectedClothingType == 'Купальник') {
      double adjustment = 0.0;
      if (selectedAgeCategory == 'Малыш') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 4:
              calculatedMeasurements.add(value - 1);
              break;
            case 5:
              calculatedMeasurements.add(value - 1);
              break;
            case 6:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 7:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 8:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add(value - 1);
              break;
            case 11:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 12:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 13:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 14:
              calculatedMeasurements.add(value - 1);
              break;
            case 15:
              calculatedMeasurements.add(value - 1);
              break;
            case 16:
              calculatedMeasurements.add(value);
              break;
            case 17:
              calculatedMeasurements.add(value);
              break;
            case 18:
              calculatedMeasurements.add(value);
              break;
            case 19:
              calculatedMeasurements.add(value);
              break;
            case 20:
              calculatedMeasurements.add(value);
              break;
            case 21:
              calculatedMeasurements.add(value);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Девочка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 4:
              calculatedMeasurements.add(value - 1);
              break;
            case 5:
              calculatedMeasurements.add(value - 1);
              break;
            case 6:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 7:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 8:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add(value - 1);
              break;
            case 11:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 12:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 13:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 14:
              calculatedMeasurements.add(value - 1);
              break;
            case 15:
              calculatedMeasurements.add(value - 1);
              break;
            case 16:
              calculatedMeasurements.add(value);
              break;
            case 17:
              calculatedMeasurements.add(value);
              break;
            case 18:
              calculatedMeasurements.add(value);
              break;
            case 19:
              calculatedMeasurements.add(value);
              break;
            case 20:
              calculatedMeasurements.add(value);
              break;
            case 21:
              calculatedMeasurements.add(value);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Юниорка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 2) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 3:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 4:
              calculatedMeasurements.add(value - 1);
              break;
            case 5:
              calculatedMeasurements.add(value - 1);
              break;
            case 6:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 7:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 8:
              calculatedMeasurements.add((value - 1) / 2);
              break;
            case 9:
              calculatedMeasurements.add(value - 1);
              break;
            case 10:
              calculatedMeasurements.add(value - 1);
              break;
            case 11:
              calculatedMeasurements.add(value - adjustment);
              break;
            case 12:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 13:
              calculatedMeasurements.add((value - 2) / 2);
              break;
            case 14:
              calculatedMeasurements.add(value - 1);
              break;
            case 15:
              calculatedMeasurements.add(value - 1);
              break;
            case 16:
              calculatedMeasurements.add(value);
              break;
            case 17:
              calculatedMeasurements.add(value);
              break;
            case 18:
              calculatedMeasurements.add(value);
              break;
            case 19:
              calculatedMeasurements.add(value);
              break;
            case 20:
              calculatedMeasurements.add(value);
              break;
            case 21:
              calculatedMeasurements.add(value);
              break;
          }
        }
      }
    } else if (selectedClothingType == 'Лосины') {
      double adjustment = 0.0;
      if (selectedAgeCategory == 'Малыш') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 3) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 3:
              calculatedMeasurements.add((value - 3) / 2);
              break;
            case 4:
              calculatedMeasurements.add(value / 2);
              break;
            case 5:
              calculatedMeasurements.add(value / 2);
              break;
            case 6:
              calculatedMeasurements.add(((value - 3) * 90) / 100);
              break;
            case 7:
              calculatedMeasurements.add(((value - 2) * 90) / 100);
              break;
            case 8:
              calculatedMeasurements.add(((value - 1) * 90) / 100);
              break;
            case 9:
              calculatedMeasurements.add((value - 2) / 2);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Девочка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 4) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 4) / 2);
              break;
            case 3:
              calculatedMeasurements.add((value - 4) / 2);
              break;
            case 4:
              calculatedMeasurements.add(value / 2);
              break;
            case 5:
              calculatedMeasurements.add(value / 2);
              break;
            case 6:
              calculatedMeasurements.add(((value - 3) * 90) / 100);
              break;
            case 7:
              calculatedMeasurements.add(((value - 2) * 90) / 100);
              break;
            case 8:
              calculatedMeasurements.add(((value - 1) * 90) / 100);
              break;
            case 9:
              calculatedMeasurements.add((value - 2) / 2);
              break;
          }
        }
      } else if (selectedAgeCategory == 'Юниорка') {
        if (selectedSleeveType == 'Длинный') {
          adjustment = 2.0;
        }
        for (int i = 0;
            i < measurementNames[selectedClothingType]!.length;
            i++) {
          double value = double.parse(measurements[i]);
          switch (i) {
            case 0:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 1:
              calculatedMeasurements.add((value - 5) / 4);
              break;
            case 2:
              calculatedMeasurements.add((value - 5) / 2);
              break;
            case 3:
              calculatedMeasurements.add((value - 5) / 2);
              break;
            case 4:
              calculatedMeasurements.add(value / 2);
              break;
            case 5:
              calculatedMeasurements.add(value / 2);
              break;
            case 6:
              calculatedMeasurements.add(((value - 3) * 90) / 100);
              break;
            case 7:
              calculatedMeasurements.add(((value - 2) * 90) / 100);
              break;
            case 8:
              calculatedMeasurements.add(((value - 1) * 90) / 100);
              break;
            case 9:
              calculatedMeasurements.add((value - 2) / 2);
              break;
          }
        }
      }
    }

    return calculatedMeasurements;
  }

  @override
  void initState() {
    super.initState();
    measurements =
        List.filled(measurementNames[selectedClothingType]!.length, '');
  }

  @override
  // В методе build:
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание лекала'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: selectedClothingType,
              items: clothingTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClothingType = value.toString();
                  measurements = List.filled(
                      measurementNames[selectedClothingType]!.length, '');
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedAgeCategory,
              items: ageCategories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAgeCategory = value.toString();
                });
              },
            ),
            SizedBox(height: 20),
            // Условная логика для скрытия DropdownButtonFormField
            if (selectedClothingType !=
                'Лосины') // Проверяем, не выбран ли тип "Лосины"
              DropdownButtonFormField(
                value: selectedSleeveType,
                items: sleeveTypes.map((sleeve) {
                  return DropdownMenuItem(value: sleeve, child: Text(sleeve));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSleeveType = value.toString();
                  });
                },
              ),
            SizedBox(height: 20),
            Text('Введите замеры:'),
            Column(
              children: List.generate(
                  measurementNames[selectedClothingType]!.length, (index) {
                return TextFormField(
                  decoration: InputDecoration(
                      labelText:
                          measurementNames[selectedClothingType]![index]),
                  onChanged: (value) {
                    _handleMeasurementChange(index, value);
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      List<double> calculatedMeasurements =
                          calculateMeasurements();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            calculatedMeasurements,
                            measurementNames[selectedClothingType]!,
                            measurements,
                          ),
                        ),
                      );
                    },
                    child: Text('Вычислить'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
