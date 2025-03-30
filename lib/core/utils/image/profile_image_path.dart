import 'package:path_provider/path_provider.dart';

Future<String> getProfileImagePath(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/$filename";
} 