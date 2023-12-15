import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'fileViewPage.dart';

class FolderContentsPageBAS extends StatefulWidget {
  final String folderName;
  final List<String> contents;

  const FolderContentsPageBAS({
    Key? key,
    required this.folderName,
    required this.contents,
  }) : super(key: key);

  @override
  _FolderContentsPageBASState createState() => _FolderContentsPageBASState();
}

class _FolderContentsPageBASState extends State<FolderContentsPageBAS> {
  List<String> _contents = [];
  bool fileOpened = false;
  String _selectedFilter = ''; // Добавленная переменная для фильтрации

  @override
  void initState() {
    super.initState();
    _contents = widget.contents;
  }

  Future<void> _openInAutoCAD(String filePath) async {
    try {
      // Замените 'C:\\Program Files\\AutoCAD\\acad.exe' на реальный путь к исполняемому файлу AutoCAD
      final autoCADPath = 'C:\\Program Files\\AutoCAD\\acad.exe';

      // Запускаем AutoCAD с передачей файла в качестве аргумента
      await Process.run(autoCADPath, [filePath]);

      print('File opened in AutoCAD');
    } catch (e) {
      print('Error opening file in AutoCAD: $e');
    }
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
        title: Text(widget.folderName,
          textAlign: TextAlign.center,
        ),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: _buildContentsList(context),
    );
  }

  Widget _buildContentsList(BuildContext context) {
    List<String> filteredContents = _contents.where((item) {
      String itemName = item.split('/').last.toLowerCase();
      return itemName.contains(_selectedFilter);
    }).toList();

    return filteredContents.isEmpty
        ? Center(child: Text('No results'))
        : ListView.builder(
            itemCount: filteredContents.length,
            itemBuilder: (context, index) {
              String itemName = filteredContents[index];
              if (itemName.endsWith('.keep') || itemName.endsWith('.txt')) {
                return SizedBox.shrink();
              }

              String fileName = itemName.split('/').last;
              if (fileName.endsWith('.bas')) {
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
                          TextButton(
                            child: Text(
                              "Открыть в AutoCAD",
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _openInAutoCAD(
                                  itemName); // Открываем файл в AutoCAD
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

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Выберите фильтр"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption("Лосины"),
              _buildFilterOption("Комбинезон"),
              _buildFilterOption("Купальник"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = filter.toLowerCase();
        });
        Navigator.pop(context); // Закрываем диалоговое окно после выбора опции
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          filter,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
