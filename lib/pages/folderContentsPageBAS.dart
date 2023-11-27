import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';

class FolderContentsPageBAS extends StatelessWidget {
  final String folderName;
  final List<String> contents;

  const FolderContentsPageBAS({
      Key? key,
    required this.folderName,
    required this.contents,
  }) : super(key: key);

  Future<String> _loadFileContents(String filePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(filePath);
      final downloadUrl = await ref.getDownloadURL();

      final httpHeaders = await ref.getMetadata();
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(downloadUrl));
      final httpClientResponse = await request.close();

      if (httpClientResponse.statusCode == HttpStatus.ok) {
        final List<int> bytes = await httpClientResponse.fold<List<int>>(
          <int>[],
          (previous, element) => previous..addAll(element),
        );

        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/tempFile.txt';

        final file = File(tempPath);
        await file.writeAsBytes(bytes);

        return await file.readAsString();
      } else {
        print('Failed to download file: HTTP ${httpClientResponse.statusCode}');
        return '';
      }
    } catch (e) {
      print("Error loading file: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$folderName'),
      ),
      body: _buildContentsList(context),
    );
  }

  Widget _buildContentsList(BuildContext context) {
    return contents.isEmpty
        ? Center(child: Text('Папка пуста'))
        : ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              String itemName = contents[index];

              // Проверка на расширение файла .keep и пропуск его отображения
              if (itemName.endsWith('.keep') || itemName.endsWith('.txt')) {
                return SizedBox.shrink(); // Пропуск отображения файла .keep или .bas
              }

              String fileName = itemName.split('/').last;
              // Удаление расширения .txt из имени файла
              if (fileName.endsWith('.bas')) {
                fileName = fileName.substring(0, fileName.length - 4);
              }

              return ListTile(
                title: Text(
                    fileName), // Отображение имени файла без расширения .txt
                onTap: () async {
                  String fileContents = await _loadFileContents(itemName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileViewPage(
                        fileName: fileName,
                        fileContents: fileContents,
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}
