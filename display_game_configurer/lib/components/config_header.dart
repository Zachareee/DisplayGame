import '../utils/config_editor.dart';
import 'package:flutter/material.dart';

typedef ConfigSet = ({
  TextEditingController appname,
  String title,
  String thumbnail,
});

class ConfigHeader extends StatefulWidget {
  const ConfigHeader({super.key, required this._onConfigLoaded});

  final Function(List<ConfigSet>) _onConfigLoaded;

  @override
  State<ConfigHeader> createState() => _ConfigHeader();
}

class _ConfigHeader extends State<ConfigHeader> {
  TextEditingController controller = .new(text: "");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextField(enabled: false, controller: controller)),
        TextButton.icon(
          onPressed: () async {
            if (await ConfigEditor.loadConfig()
                case (:final path, :final entries)?) {
              controller.text = path;
              widget._onConfigLoaded(
                entries
                    .map(
                      (e) => (
                        appname: TextEditingController(text: e.appname),
                        title: e.title,
                        thumbnail: e.thumbnail,
                      ),
                    )
                    .toList(),
              );
            }
          },
          label: const Text("Load"),
          icon: const Icon(Icons.upload),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
