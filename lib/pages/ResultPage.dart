import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final List<double> calculatedMeasurements;
  final List<String> measurementNames;

  ResultPage(this.calculatedMeasurements, this.measurementNames);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты'),
      ),
      body: ListView.builder(
        itemCount: measurementNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(measurementNames[index]),
            subtitle: Text('Значение: ${calculatedMeasurements[index].toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
