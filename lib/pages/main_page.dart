import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<Folder> folders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            title: Text(folder.name),
            onTap: () {
              // Переход в папку
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetailPage(folder),
                ),
              );
            },
            onLongPress: () {
              // Длинное нажатие для изменения имени и удаления папки
              showDialog(
                context: context,
                builder: (context) {
                  String folderName = folder.name;
                  return AlertDialog(
                    title: Text('Изменить имя папки'),
                    content: TextField(
                      onChanged: (value) {
                        folderName = value;
                      },
                      controller: TextEditingController(text: folder.name),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Отмена
                          Navigator.of(context).pop();
                        },
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Сохранение измененного имени папки
                          if (folderName.isNotEmpty) {
                            setState(() {
                              folder.name = folderName;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('Сохранить'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Подтверждение удаления папки
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Удалить папку?'),
                                content: Text('Вы уверены, что хотите удалить эту папку?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Отмена
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Удаление папки
                                      setState(() {
                                        folders.remove(folder);
                                      });
                                      Navigator.of(context).pop();
                                      // Закрыть второе диалоговое окно и первое диалоговое окно
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Удалить'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Удалить'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Добавление новой папки
          showDialog(
            context: context,
            builder: (context) {
              String folderName = '';
              return AlertDialog(
                title: Text('Добавить папку'),
                content: TextField(
                  onChanged: (value) {
                    folderName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Отмена
                      Navigator.of(context).pop();
                    },
                    child: Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Добавление папки
                      if (folderName.isNotEmpty) {
                        setState(() {
                          folders.add(Folder(name: folderName));
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Добавить'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Folder {
  String name;

  Folder({required this.name});
}

class FolderDetailPage extends StatelessWidget {
  final Folder folder;

  FolderDetailPage(this.folder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: Center(
        child: Text('Содержимое папки "${folder.name}"'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FolderPage(),
  ));
}
