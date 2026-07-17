import 'dart:async';
import 'package:display_game_configurer/components/search_header.dart';
import 'package:display_game_configurer/components/search_table.dart';
import 'package:display_game_configurer/utils/igdbcover.dart';
import 'package:flutter/material.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key});

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

  void updateTable(List<Game> games) => setState(() {
    table = games;
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: .start,
        spacing: 32,
        children: [
          SearchHeader(onSearchChanged: _onSearchChanged),
          SearchTable(table: table),
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
