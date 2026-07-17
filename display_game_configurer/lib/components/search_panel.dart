import 'dart:async';
import './search_header.dart';
import './search_table.dart';
import '../utils/igdbcover.dart';
import 'package:flutter/material.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, required this.addEntry});

  final Function(TextEditingController, String, String) addEntry;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  List<Game> table = [];
  Timer? _debounce;

  // https://stackoverflow.com/a/52930197/7011902
  void _onSearchChanged(String query, int rowCount) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const .new(milliseconds: 500), () {
      Igdbcover.authenticate()
          .then((value) => value.search(query, limit: rowCount))
          .then(
            (result) => setState(() {
              table = result;
            }),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: .start,
        spacing: 32,
        children: [
          SearchHeader(onSearchChanged: _onSearchChanged),
          SearchTable(table: table, addEntry: widget.addEntry),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
