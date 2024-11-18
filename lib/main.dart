import 'package:battleships/models/status_notifier..dart';
import 'package:battleships/views/battleships.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameListNotifier(),
      child: const Battleships(),
    ),
  );
}
