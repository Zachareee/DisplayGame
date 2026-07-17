import 'package:display_game_configurer/utils/igdbcover.dart';
import 'package:display_game_configurer/utils/config_editor.dart';
import 'package:flutter/material.dart';

class SearchTable extends StatelessWidget {
  SearchTable({super.key, required this.table});

  final List<Game> table;

  final TableRow header = TableRow(
    children: ["Title", "Release Date", "Platforms", "Cover", "Action"]
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

  List<TableRow> convertToRows() => [
    header,
    ...table.map(
      (row) => TableRow(
        children: [
          ...[
            row.name,
            DateTime.fromMillisecondsSinceEpoch(
              (row.firstReleaseDate ?? 0) * 1000,
            ).toIso8601String().split("T")[0],
            row.platforms?.join(", ") ?? "",
          ].map((s) => Text(s, textAlign: .center)),
          Image(image: NetworkImage(row.cover), height: 64),
          Center(child: ElevatedButton.icon(
            onPressed: () {
              ConfigEditor.addEntry(row.name, row.cover);
            },
            icon: const Icon(Icons.add),
            label: const Text("Add"),
          )),
        ].map((value) => TableCell(child: value)).toList(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: .middle,
          border: TableBorder.all(),
          columnWidths: const {1: IntrinsicColumnWidth()},
          children: convertToRows(),
        ),
      ),
    );
  }
}
