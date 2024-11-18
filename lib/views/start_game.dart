import 'package:battleships/views/game_screen.dart';
import 'package:battleships/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/session_controller.dart';
import 'dart:convert';

class StartGame extends StatefulWidget {
  final int gameId;

  const StartGame({super.key, required this.gameId});

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  List<String> selectedPositions = [];
  int? _userPosition;
  List<String> _shotsTaken = [];
  bool _isUserTurn = false;
  bool _isGameActive = false;
  String? _pendingShot;

  List<String> myShips = [];
  List<String> myShots = [];
  List<String> myHits = [];
  List<String> mySunkShips = [];

  bool _hasWon = false;
  bool _hasLost = false;

  @override
  void initState() {
    super.initState();
    fetchGameInfo();
  }

  String baseUrl = "http://165.227.117.48";

  Future<void> _redirectToLogin() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScrn()),
    );
  }

  Future<void> fetchGameInfo() async {
    var url = Uri.parse('$baseUrl/games/${widget.gameId}');
    String? token = await SessionManager.getSessionToken();

    if (token == '') {
      print('Authorization token is missing.');
      return;
    }

    var response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _shotsTaken = List<String>.from(data['shots']);
        _userPosition = data['position'];
        print("User Position: $_userPosition, Turn: ${data['turn']}");

        _isUserTurn = data['turn'] == _userPosition;

        myShips = List<String>.from(data['ships']);
        myShots = List<String>.from(data['shots']);
        myHits = List<String>.from(data['sunk']);
        mySunkShips = List<String>.from(data['wrecks']);

        _hasWon = myHits.length >= 5;
        _hasLost = mySunkShips.length >= 5;

        _isGameActive = data['status'] == 0 || data['status'] == 3;
      });
      if (_hasWon || _hasLost) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _showEndGameDialog());
      }
    } else if (response.statusCode == 401) {

      await _redirectToLogin();
    } else {
      print('Error fetching game info: ${response.body}');
    }
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.teal[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _hasWon ? 'You won!' : 'You lost!',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _hasWon
                        ? 'Victory! All enemy ships have been sunk by your hand.'
                        : ' Better luck next time. Your ships have been sunk.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 18, 134, 138),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Games()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onCellTap(String pos) async {
    if (!_isGameActive) {
      _showSnackbar(context, "The game is not active.");
      return;
    }

    if (!_isUserTurn) {
      _showSnackbar(context, "It's not your turn.");
      return;
    }

    if (_shotsTaken.contains(pos) || myHits.contains(pos)) {
      _showSnackbar(context, "You already attacked here.");
      return;
    }

    _pendingShot = pos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hasWon || _hasLost) {
        _showEndGameDialog();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Play Game',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.teal[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final aspectRatio = constraints.maxWidth / constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: 36,
                itemBuilder: (context, index) {
                  if (index < 6) {
                    return Center(
                      child: Text(
                        index == 0 ? '' : '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else if (index % 6 == 0) {
                    int row = (index / 6).floor();
                    return Center(
                      child: Text(
                        String.fromCharCode('A'.codeUnitAt(0) + row - 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                 
                  int row = (index / 6).floor();
                  int col = index % 6;
                  String pos =
                      '${String.fromCharCode('A'.codeUnitAt(0) + row - 1)}$col';

                  String cellContent = '';

                  if (myShips.contains(pos)) {
                    cellContent += '🚢';
                  }
                  if (myShots.contains(pos) && !myHits.contains(pos)) {
                    cellContent += '💣';
                  }
                  if (myHits.contains(pos)) {
                    cellContent += '💥';
                  }
                  if (mySunkShips.contains(pos)) {
                    cellContent += '💦';
                  }

                  return InkWell(
                    onTap: (() => onCellTap(pos)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white, width: 1), 
                        color: selectedPositions.contains(pos) ||
                                pos == _pendingShot
                            ? const Color.fromARGB(255, 2, 74, 83)
                            : null,
                      ),
                      child: Text(
                        cellContent,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pendingShot != null && _isUserTurn
                  ? () => submitShot(_pendingShot!)
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 18, 134, 138)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitShot(String shot) async {
    var url = Uri.parse('$baseUrl/games/${widget.gameId}');
    String? token = await SessionManager.getSessionToken();

    if (token == '') {
      print('Authorization token is missing.');
      return;
    }

    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"shot": shot}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      bool won = data['won'];

      fetchGameInfo();

      setState(() {
        _pendingShot = null;
      });

      if (won) {
        _showEndGameDialog();
      }
    } else {
      print('Error submitting shot: ${response.body}');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
