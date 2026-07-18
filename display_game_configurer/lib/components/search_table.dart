import './abstract_table.dart';
import '../utils/igdbcover.dart';
import 'package:flutter/material.dart';

class SearchTable extends AbstractTable {
  SearchTable({
    super.key,
    super.header = const [
      "Title",
      "Release Date",
      "Platforms",
      "Cover",
      "Action",
    ],
    super.columnWidths = const {1: IntrinsicColumnWidth()},
    required this.table,
    required this.addEntry,
  });

  final List<Game> table;
  final Function(TextEditingController, String, String) addEntry;

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

  @override
  List<List<Widget>> content(BuildContext context) => table.map((row) {
    return [
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
    ];
  }).toList();
}
