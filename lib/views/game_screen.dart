import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/status_notifier..dart';
import '../models/game_state.dart';
import '../utils/session_controller.dart';
import 'loginpage.dart';
import 'game_setup.dart';
import 'start_game.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  String _username = '';
  bool _showCompletedGames = false;
  String baseUrl = 'http://165.227.117.48';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await SessionManager.getUsername();
    if (mounted) {
      setState(() {
        _username = username ?? 'Guest';
      });
    }
  }

  Future<void> _logout() async {
    await SessionManager.clearSession();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScrn()),
      );
    }
  }

  void _showAIDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose AI Type',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 13, 52, 71),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                var gameListNotifier =
                    Provider.of<GameListNotifier>(context, listen: false);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Newgame(gameType: 1)),
                );
                gameListNotifier.fetchGames();
              },
              child: const Text('Random AI',
                  style: TextStyle(color: Colors.white)),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                var gameListNotifier =
                    Provider.of<GameListNotifier>(context, listen: false);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Newgame(gameType: 2)),
                );
                gameListNotifier.fetchGames();
              },
              child: const Text('Perfect AI',
                  style: TextStyle(color: Colors.white)),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                var gameListNotifier =
                    Provider.of<GameListNotifier>(context, listen: false);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Newgame(gameType: 3)),
                );
                gameListNotifier.fetchGames();
              },
              child: const Text('Oneship AI',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameListNotifier = Provider.of<GameListNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Battleships', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => gameListNotifier.fetchGames(),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[800]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30.0,
                    child: Icon(Icons.person, size: 30.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _username,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.black),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.blue[800]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: const Text(
                  'New Game',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
              onTap: () async {
                var gameListNotifier =
                    Provider.of<GameListNotifier>(context, listen: false);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Newgame(gameType: 0)),
                );
                gameListNotifier.fetchGames();
              },
            ),
            ListTile(
              leading: const Icon(Icons.computer, color: Colors.black),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.blue[800]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: const Text(
                  'Versus AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () => _showAIDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.menu, color: Colors.black),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.blue[800]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  _showCompletedGames
                      ? 'Show Active Games'
                      : 'Show Completed Games',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                setState(() => _showCompletedGames = !_showCompletedGames);
                gameListNotifier.fetchGames();
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.blue[800]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () => _logout(),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.teal[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: gameListNotifier.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                itemCount: gameListNotifier.games.length,
                itemBuilder: (context, index) {
                  Game game = gameListNotifier.games[index];
                  if ((_showCompletedGames &&
                          (game.status == 1 || game.status == 2)) ||
                      (!_showCompletedGames &&
                          (game.status == 0 || game.status == 3))) {
                    return _buildGameTile(game, gameListNotifier);
                  }
                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }

  Widget _buildGameTile(Game game, GameListNotifier gameListNotifier) {
    String status = _getGameStatus(game.status);
    String opponent = game.player2 ?? 'Waiting for opponent';
    String turnMessage = _getTurnMessage(game, opponent);

    // For active games, return a Dismissible widget
    if (game.status == 0 || game.status == 3) {
      return Dismissible(
        key: Key(game.id.toString()),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          _forfeitGame(game.id, gameListNotifier);
        },
        child: ListTile(
          title: Text('Game ID: ${game.id}',
              style: const TextStyle(color: Colors.white)),
          subtitle: Text('Players: ${game.player1} vs $opponent',
              style: const TextStyle(color: Colors.white)),
          trailing: Text('Status: $status, Turn: $turnMessage',
              style: const TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (_) => StartGame(gameId: game.id),
                ))
                .then((value) => _refreshGames(gameListNotifier));
          },
        ),
      );
    } else {
    
      return ListTile(
        title: Text('Game ID: ${game.id}',
            style: const TextStyle(color: Colors.white)),
        subtitle: Text('Players: ${game.player1} vs $opponent',
            style: const TextStyle(color: Colors.white)),
        trailing: Text('Status: $status, Turn: $turnMessage',
            style: const TextStyle(color: Colors.white)),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => StartGame(gameId: game.id),
              ))
              .then((value) => _refreshGames(gameListNotifier));
        },
      );
    }
  }

  String _getGameStatus(int status) {
    switch (status) {
      case 0:
        return "Matchmaking";
      case 1:
        return "Won by Player 1";
      case 2:
        return "Won by Player 2";
      case 3:
        return "Playing";
      default:
        return "Unknown";
    }
  }

  String _getTurnMessage(Game game, String opponent) {
    if (game.turn == 0) {
      return "Not Active";
    } else if (game.turn == 1) {
      return game.player1;
    } else if (game.turn == 2 && opponent != 'Waiting for opponent') {
      return opponent;
    } else {
      return "Waiting for Turn";
    }
  }

  Future<void> _redirectToLogin() async {
    await SessionManager.clearSession();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScrn()),
    );
  }

  Future<void> _forfeitGame(int id, GameListNotifier gameListNotifier) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/games/$id'),
      headers: {
        'Authorization': 'Bearer ${await SessionManager.getSessionToken()}',
      },
    );

    if (response.statusCode == 200) {
      print('Game deleted successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Game deleted successfully'),
          duration: Duration(milliseconds: 500),
        ));
      }
    } else if (response.statusCode == 401) {
      await _redirectToLogin();
    } else {
      print('Error deleting game: ${response.body}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error deleting game: ${response.body}'),
          duration: const Duration(milliseconds: 500),
        ));
      }
    }

    _refreshGames(gameListNotifier);
  }

  Future<void> _refreshGames(GameListNotifier gameListNotifier) async {
    gameListNotifier.fetchGames();
  }
}
