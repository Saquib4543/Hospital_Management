import 'dart:html' as html;
import 'package:http/http.dart' as http;

Future<void> downloadFileWeb(String url, String filename) async {
  final response = await http.get(Uri.parse(url));
  final blob = html.Blob([response.bodyBytes]);
  final urlObject = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: urlObject)
    ..setAttribute("download", filename)
    ..click();
  html.Url.revokeObjectUrl(urlObject);
}