import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

/// Abre el selector de archivos nativo en plataformas nativas (Android/iOS/desktop).
Future<Uint8List?> pickPdfBytes() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: true,
  );
  return result?.files.single.bytes;
}
