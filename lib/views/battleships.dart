import 'package:flutter/material.dart';
import '../utils/session_controller.dart';
import 'loginpage.dart';
import 'game_screen.dart';

class Battleships extends StatefulWidget {
  const Battleships({super.key});

  @override
  State<Battleships> createState() => _BattleshipsState();
}

class _BattleshipsState extends State<Battleships> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    SessionManager.clearSession;
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battleships',
      home: isLoggedIn ? const Games() : const LoginScrn(),
    );
  }
}
