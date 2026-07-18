import './abstract_table.dart';

import './config_header.dart';
import 'package:flutter/material.dart';

class ConfigTable extends AbstractTable {
  ConfigTable({
    super.key,
    super.header = const ["App name", "Title", "Cover", "Action"],
    required this.config,
    required this._removeEntry,
  });

  final List<ConfigSet> config;
  final Function(int) _removeEntry;

  Future<dynamic> configDialog(BuildContext context, String appname, int idx) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete $appname?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _removeEntry(idx);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  List<List<Widget>> content(BuildContext context) =>
      config.asMap().entries.map((entry) {
        final MapEntry(:key, :value) = entry;
        return [
          TextField(
            controller: value.appname,
            textAlign: .center,
            minLines: 1,
            maxLines: 3,
          ),
          Text(value.title, textAlign: .center),
          Image(image: NetworkImage(value.thumbnail), height: 64),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => configDialog(context, value.appname.text, key),
              label: const Text("Remove"),
              icon: const Icon(Icons.remove),
            ),
          ),
        ];
      }).toList();
}
