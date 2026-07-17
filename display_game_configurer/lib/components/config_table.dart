import './config_header.dart';
import 'package:flutter/material.dart';

class ConfigTable extends StatelessWidget {
  ConfigTable({super.key, required this.config, required this._removeEntry});

  final List<ConfigSet> config;
  final Function(int) _removeEntry;

  final TableRow header = TableRow(
    children: ["App name", "Title", "Cover", "Action"]
        .map(
          (e) => TableCell(
            child: Padding(
              padding: .all(8),
              child: Text(
                e,
                style: .new(fontWeight: .bold),
                textAlign: .center,
              ),
            ),
          ),
        )
        .toList(),
  );

  List<TableRow> convertToRows(BuildContext context) => [
    header,
    ...config.asMap().entries.map((entry) {
      final MapEntry(:key, value: record) = entry;
      return TableRow(
        children: [
          TableCell(
            child: TextField(
              controller: record.appname,
              textAlign: .center,
              minLines: null,
              maxLines: null,
            ),
          ),
          TableCell(child: Text(record.title, textAlign: .center)),
          TableCell(
            child: Image(image: NetworkImage(record.thumbnail), height: 64),
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
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: .middle,
          border: .all(),
          columnWidths: const {2: IntrinsicColumnWidth()},
          children: convertToRows(context),
        ),
      ),
    );
  }
}
