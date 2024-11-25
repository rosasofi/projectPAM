import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_pam/main.dart'; // Pastikan path import sesuai dengan struktur folder Anda

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build widget MyApp dan trigger frame pertama
    await tester.pumpWidget(const MyApp() as Widget);

    // Verifikasi bahwa counter dimulai dengan 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap ikon '+' dan trigger frame berikutnya
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter bertambah menjadi 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class MyApp {
  const MyApp();
}
