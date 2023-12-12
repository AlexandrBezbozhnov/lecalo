import 'package:flutter/material.dart';

class EditFilePage extends StatefulWidget {
  final String fileContents;

  EditFilePage({required this.fileContents});

  @override
  _EditFilePageState createState() => _EditFilePageState();
}

class _EditFilePageState extends State<EditFilePage> {
  late List<String> fileLines;

  @override
  void initState() {
    super.initState();
    fileLines = widget.fileContents.split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit File'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(fileLines.length, (index) {
              final line = fileLines[index];
              final keyValue = line.split(': ');
              final variable = keyValue[0];
              final value = keyValue.length > 1 ? keyValue[1] : '';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(variable),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: value,
                        onChanged: (newValue) {
                          setState(() {
                            fileLines[index] = '$variable: $newValue';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Здесь вы можете отправить обновленное содержимое файла обратно на страницу FileViewPage
          // Используйте Navigator.pop с передачей нового содержимого файла
          Navigator.pop(context, fileLines.join('\n'));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
