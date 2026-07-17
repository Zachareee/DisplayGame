import '../components/config_header.dart';
import '../components/config_table.dart';
import 'package:flutter/material.dart';

class ConfigPanel extends StatelessWidget {
  const ConfigPanel({
    super.key,
    required this.configs,
    required this._onConfigLoaded,
    required this._removeEntry,
  });

  final List<ConfigSet> configs;
  final Function(List<ConfigSet>) _onConfigLoaded;
  final Function(int) _removeEntry;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ConfigHeader(onConfigLoaded: _onConfigLoaded),
          ConfigTable(config: configs, removeEntry: _removeEntry),
        ],
      ),
    );
  }
}
