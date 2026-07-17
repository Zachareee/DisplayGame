import 'package:flutter/material.dart';
import 'components/search_panel.dart';
import 'components/config_panel.dart';
import 'components/config_header.dart';
import 'utils/config_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      home: const MyHomePage(title: 'DisplayGame config editor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  List<ConfigSet> configs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              SearchPanel(
                addEntry: (controller, title, thumbnail) => setState(
                  () => configs.add((
                    appname: controller,
                    title: title,
                    thumbnail: thumbnail,
                  )),
                ),
              ),
              const VerticalDivider(thickness: 2),
              ConfigPanel(
                configs: configs,
                onConfigLoaded: (list) => setState(() => configs = list),
                removeEntry: (idx) =>
                    setState(() => configs.removeAt(idx).appname.dispose()),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => ConfigEditor.saveConfig(
          configs
              .map(
                (e) => (
                  appname: e.appname.text,
                  title: e.title,
                  thumbnail: e.thumbnail,
                ),
              )
              .toList(),
        ),
        label: Text("Save"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
