import 'package:flutter/material.dart';

abstract class AbstractTable extends StatelessWidget {
  AbstractTable({super.key, required List<String> header, this.columnWidths}) {
    this.header = TableRow(
      children: header
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
  }

  late final TableRow header;
  final Map<int, TableColumnWidth>? columnWidths;
  List<List<Widget>> content(BuildContext context);

  List<TableRow> _convertToRows(BuildContext context) => [
    header,
    ...content(context).map(
      (e) => TableRow(
        children: e
            .map(
              (f) => TableCell(
                child: Padding(padding: .all(6), child: f),
              ),
            )
            .toList(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: .middle,
          border: .all(),
          columnWidths: columnWidths,
          children: _convertToRows(context),
        ),
      ),
    );
  }
}
