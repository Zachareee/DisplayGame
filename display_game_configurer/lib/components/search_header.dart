import 'package:flutter/material.dart';

const List<int> rowCounts = [5, 10, 25, 50, 100, 200, 500];

class SearchHeader extends StatefulWidget {
  const SearchHeader({super.key, required this._onSearchChanged});

  final Function(String, int) _onSearchChanged;

  @override
  State<SearchHeader> createState() => _SearchHeader();
}

class _SearchHeader extends State<SearchHeader> {
  int rowCount = rowCounts.first;
  String query = "";

  void updateSearch() => widget._onSearchChanged(query, rowCount);

  @override
  Widget build(BuildContext context) {
    updateSearch();
    return Row(
      mainAxisAlignment: .center,
      spacing: 32,
      children: [
        Text("Search", style: Theme.of(context).textTheme.displaySmall),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => query = value),
          ),
        ),
        DropdownButton(
          value: rowCount,
          items: rowCounts
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.toString()),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => rowCount = value);
          },
        ),
      ],
    );
  }
}
