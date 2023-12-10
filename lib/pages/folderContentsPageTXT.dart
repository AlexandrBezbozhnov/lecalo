import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';

class FolderContentsPageTXT extends StatefulWidget {
  final String folderName;
  final List<String> contents;

  const FolderContentsPageTXT({
    Key? key,
    required this.folderName,
    required this.contents,
  }) : super(key: key);

  @override
  _FolderContentsPageTXTState createState() => _FolderContentsPageTXTState();
}

class _FolderContentsPageTXTState extends State<FolderContentsPageTXT> {
  List<String> _contents = [];
  String _searchQuery = '';
  bool fileOpened = false; // Добавленная переменная
  // Переменная для хранения запроса поиска

  @override
  void initState() {
    super.initState();
    _contents = widget.contents;
  }

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

  Future<void> _deleteFile(String filePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.delete();
      print('File deleted successfully');
      setState(() {
        _contents.remove(filePath); // удаление файла из списка
      });
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value
                      .toLowerCase(); // Обновление запроса поиска при изменении текста в поле
                });
              },
              decoration: InputDecoration(
                labelText: 'Поиск файлов',
                hintText: 'Введите название файла',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _buildContentsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContentsList(BuildContext context) {
    List<String> filteredContents = _contents.where((item) {
      String itemName = item.split('/').last.toLowerCase();
      return itemName.contains(_searchQuery);
    }).toList();

    return filteredContents.isEmpty
        ? Center(child: Text('No results'))
        : ListView.builder(
            itemCount: filteredContents.length,
            itemBuilder: (context, index) {
              String itemName = filteredContents[index];

              if (itemName.endsWith('.keep') || itemName.endsWith('.bas')) {
                return SizedBox.shrink();
              }

              String fileName = itemName.split('/').last;
              if (fileName.endsWith('.txt')) {
                fileName = fileName.substring(0, fileName.length - 4);
              }

              return ListTile(
                title: Text(fileName),
                onTap: () async {
                  if (!fileOpened) {
                    fileOpened = true; // Установка флага, что файл открыт

                    String fileContents = await _loadFileContents(itemName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FileViewPage(
                          fileName: fileName,
                          fileContents: fileContents,
                          folderName: itemName,
                        ),
                      ),
                    ).then((_) {
                      fileOpened = false; // Сброс флага после закрытия файла
                    });
                  }
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Удалить файл?"),
                        content: Text(
                            "Вы уверены, что хотите удалить файл $fileName?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Отмена"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Удалить",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _deleteFile(itemName);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
  }
}
