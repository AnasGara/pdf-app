import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/pdf_document.dart';

class FileService {
  Future<PdfDocumentModel?> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String name = result.files.single.name;
      String path = file.path;
      String size = formatBytes(file.lengthSync());

      int pageCount = 0;
      try {
        final PdfDocument document = PdfDocument(inputBytes: file.readAsBytesSync());
        pageCount = document.pages.count;
        document.dispose();
      } catch (e) {
        print('Error reading PDF: $e');
      }

      return PdfDocumentModel(
        name: name,
        path: path,
        size: size,
        pageCount: pageCount,
        dateAdded: DateTime.now().toIso8601String(),
        lastOpened: DateTime.now().toIso8601String(),
      );
    }
    return null;
  }

  String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }
}
