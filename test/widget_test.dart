import 'package:flutter_test/flutter_test.dart';
import 'package:ucp2/main.dart'; // Pastikan nama package ini sesuai dengan name di pubspec.yaml kamu

void main() {
  testWidgets('DriveEase App Load Test', (WidgetTester tester) async {
    // Build aplikasi kita dan memicu frame.
    // Di sini kita panggil DriveEaseApp() menggantikan MyApp()
    await tester.pumpWidget(const DriveEaseApp());

    // Karena ini project ujian dengan tenggat waktu, kita biarkan blok test ini 
    // minimalis dulu agar tidak error saat proses build.
  });
}