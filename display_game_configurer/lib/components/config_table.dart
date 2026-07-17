import './abstract_table.dart';

import './config_header.dart';
import 'package:flutter/material.dart';

class ConfigTable extends AbstractTable {
  ConfigTable({
    super.key,
    super.header = const ["App name", "Title", "Cover", "Action"],
    super.columnWidths = const {2: IntrinsicColumnWidth()},
    required this.config,
    required this._removeEntry,
  });

  final List<ConfigSet> config;
  final Function(int) _removeEntry;

  @override
  List<TableRow> content(BuildContext context) =>
      config.asMap().entries.map((entry) {
        final MapEntry(:key, :value) = entry;
        return TableRow(
          children: [
            TableCell(
              child: TextField(
                controller: value.appname,
                textAlign: .center,
                minLines: null,
                maxLines: null,
              ),
            ),
            TableCell(child: Text(value.title, textAlign: .center)),
            TableCell(
              child: Image(image: NetworkImage(value.thumbnail), height: 64),
            ),
            TableCell(
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => _removeEntry(key),
                  label: const Text("Remove"),
                  icon: const Icon(Icons.remove),
                ),
              ),
            ),
          ],
        );
      }).toList();
}
