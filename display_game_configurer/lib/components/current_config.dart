import 'package:flutter/material.dart';

class CurrentConfig extends StatefulWidget {
  const CurrentConfig({super.key});

  @override
  State<StatefulWidget> createState() => _CurrentConfigState();
}

class _CurrentConfigState extends State<CurrentConfig> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        "Filler",
        textAlign: .center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
