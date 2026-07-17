import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

typedef JsonConfig = List<({String appname, String title, String thumbnail})>;

class ConfigEditor {
  ConfigEditor._();

  static String _path = "";

  static Future<({String path, JsonConfig entries})?> loadConfig() async {
    return FilePicker.pickFiles(
      dialogTitle: "Select the DisplayGame config.json",
      type: .custom,
      withData: true,
      allowedExtensions: ["json"],
    ).then((result) {
      if (result != null) {
        final file = result.files.first;
        final data =
            const Utf8Decoder().fuse(const JsonDecoder()).convert(file.bytes!)
                as Map<String, dynamic>;
        final records = data["records"] as Map<String, dynamic>;
        return (
          path: _path = file.path!,
          entries: records.entries.map((e) {
            final MapEntry(:key, :value) = e;
            return (
              appname: key,
              title: value["name"] as String,
              thumbnail: value["thumbnail"] as String,
            );
          }).toList(),
        );
      }
      return null;
    });
  }

  static void saveConfig(JsonConfig configs) {
    final file = File(_path);
    final obj = jsonDecode(file.readAsStringSync());
    obj["records"] = Map.fromEntries(
      configs.map(
        (elem) => MapEntry(elem.appname, {
          "name": elem.title,
          "thumbnail": elem.thumbnail,
        }),
      ),
    );
    file.writeAsStringSync(jsonEncode(obj));
  }
}
