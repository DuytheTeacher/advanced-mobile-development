import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFApi {
  static Future<File> loadNetwork(String url) async{
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final fileName = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}