// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

/// Abre el selector de archivos nativo del navegador y devuelve los bytes
/// del PDF seleccionado, o null si el usuario canceló.
Future<Uint8List?> pickPdfBytes() async {
  final completer = Completer<Uint8List?>();

  final input = html.FileUploadInputElement()
    ..accept = '.pdf,application/pdf'
    ..style.display = 'none';

  html.document.body!.append(input);

  input.onChange.listen((_) {
    final file = input.files?.first;
    if (file == null) {
      completer.complete(null);
      input.remove();
      return;
    }
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((_) {
      completer.complete(reader.result as Uint8List);
      input.remove();
    });
    reader.onError.listen((_) {
      completer.complete(null);
      input.remove();
    });
  });

  // Si el usuario cierra sin elegir archivo
  html.window.addEventListener('focus', (_) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!completer.isCompleted) completer.complete(null);
    });
  }, true);

  input.click();
  return completer.future;
}
