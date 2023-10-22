import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Функция для сохранения и загрузки данных
Future<void> saveAndUploadData(
  List<double> calculatedMeasurements,
  List<String> measurementNames,
  List<String> userMeasurements,
  String fileName,
) async {
  try {
    // Создайте временный файл для сохранения данных
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName.txt');

    // Запишите данные в файл
    final data = 'Сохраненные данные: $calculatedMeasurements, $measurementNames, $userMeasurements';
    await file.writeAsString(data);

    // Загрузите файл в Firebase Storage
    final FirebaseStorage storage = FirebaseStorage.instance;
    String filePath = 'uploads/$fileName.txt';

    // Выполните загрузку файла
    final ref = storage.ref().child(filePath);
    final task = ref.putFile(file);

    // Дождитесь завершения загрузки
    await task.whenComplete(() {
      print('Файл успешно записан');
      file.delete();
    });
  } catch (error) {
    // Обработка ошибки загрузки файла
    print('Ошибка при загрузке файла: $error');
  }
}