import 'package:flutter/material.dart';
import 'package:display_game_configurer/components/search_panel.dart';
import 'package:display_game_configurer/components/current_config.dart';
import 'package:display_game_configurer/utils/config_editor.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text(title)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 16,
            children: [
              const SearchPanel(),
              const VerticalDivider(thickness: 2),
              const CurrentConfig(),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: ConfigEditor.saveConfig,
        label: Text("Save"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
