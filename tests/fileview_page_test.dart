import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:lecalo/pages/fileViewPage.dart';
import 'package:flutter/services.dart';

void main() {
  testWidgets('FileViewPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: FileViewPage(
          fileName: 'testFile.txt',
          fileContents: 'Test file content',
          folderName: 'testFolder',
        ),
      ),
    );

    // Verify that the title is displayed.
    expect(find.text('testFile.txt'), findsOneWidget);

    // Verify that the initial file contents are displayed.
    expect(find.text('Test file content'), findsOneWidget);

    // Verify that the Copy button is present.
    expect(find.byIcon(Icons.copy), findsOneWidget);

    // Verify that the Delete button is present.
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // Verify that the Edit button is present.
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('Copy to Clipboard Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FileViewPage(
          fileName: 'testFile.txt',
          fileContents: 'Test file content',
          folderName: 'testFolder',
        ),
      ),
    );

    // Tap on the Copy button.
    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    // Verify that the file contents are copied to the clipboard.
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    expect(clipboardData?.text, 'Test file content');
  });

  testWidgets('Delete File Test', (WidgetTester tester) async {
    final mockStorage = MockFirebaseStorage();
    // Inject the mock storage instance.
    // This assumes that you have a way to inject dependencies into your app.
    // If not, you might need to refactor your code to allow for dependency injection.
    // For example, you could use an InheritedWidget or a service locator.
    await tester.pumpWidget(
      MaterialApp(
        home: FileViewPage(
          fileName: 'testFile.txt',
          fileContents: 'Test file content',
          folderName: 'testFolder',
        ),
      ),
    );

    // Mock the delete function of Firebase Storage.
    mockStorage.ref().child('testFolder').putData(Uint8List.fromList([]));

    // Tap on the Delete button.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Verify that the file is deleted.
    // You need to define how you want to handle navigation after deletion in your app.
  });

  // Add more tests as needed for other functionalities.
}
