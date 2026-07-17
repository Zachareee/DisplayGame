import '../utils/igdbcover.dart';
import 'package:flutter/material.dart';

class SearchTable extends StatelessWidget {
  SearchTable({super.key, required this.table, required this.addEntry});

  final List<Game> table;
  final Function(TextEditingController, String, String) addEntry;

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

  Future<dynamic> searchDialog(BuildContext context, Game row) {
    TextEditingController controller = .new();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Set app name"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addEntry(controller, row.name, row.cover);
              Navigator.of(context).pop();
            },
            child: const Text("Save app name"),
          ),
        ],
      ),
    );
  }

  List<TableRow> convertToRows(BuildContext context) => [
    header,
    ...table.map((row) {
      return TableRow(
        children: [
          ...[
            row.name,
            DateTime.fromMillisecondsSinceEpoch(
              (row.firstReleaseDate ?? 0) * 1000,
            ).toIso8601String().split("T")[0],
            row.platforms?.join(", ") ?? "",
          ].map((s) => Text(s, textAlign: .center)),
          Image(image: NetworkImage(row.cover), height: 64),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => searchDialog(context, row),
              icon: const Icon(Icons.add),
              label: const Text("Add"),
            ),
          ),
        ].map((value) => TableCell(child: value)).toList(),
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
          columnWidths: const {1: IntrinsicColumnWidth()},
          children: convertToRows(context),
        ),
      ),
    );
  }
}
