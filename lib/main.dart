import 'dart:convert';
import 'package:flutter/material.dart';
import 'story_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'character.dart';
import 'event.dart';
import 'event_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(
      duration: 2,
      goToPage: const HomeScreen(),
    ),
  ));
}

// ----------------------
// Saved Game Model & Service
// ----------------------
class SavedGame {
  final String id;
  final String name;
  final DateTime savedDate;
  final Map<String, dynamic> gameState;
  final int score;

  SavedGame({
    required this.id,
    required this.name,
    required this.savedDate,
    required this.gameState,
    required this.score,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'savedDate': savedDate.toIso8601String(),
        'gameState': gameState,
        'score': score,
      };

  factory SavedGame.fromMap(Map<String, dynamic> map) => SavedGame(
        id: map['id'],
        name: map['name'],
        savedDate: DateTime.parse(map['savedDate']),
        gameState: Map<String, dynamic>.from(map['gameState']),
        score: map['score'],
      );

  String toJson() => json.encode(toMap());
  factory SavedGame.fromJson(String source) =>
      SavedGame.fromMap(json.decode(source));
}

class GameService {
  static const String _savedGamesKey = 'saved_games';

  static Future<void> saveGame(SavedGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final savedGames = await getSavedGames();
    final index = savedGames.indexWhere((g) => g.id == game.id);
    if (index >= 0) {
      savedGames[index] = game;
    } else {
      savedGames.add(game);
    }
    final gamesJson = savedGames.map((g) => g.toJson()).toList();
    await prefs.setStringList(_savedGamesKey, gamesJson);
  }

  static Future<List<SavedGame>> getSavedGames() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesJson = prefs.getStringList(_savedGamesKey) ?? [];
    return gamesJson.map((jsonStr) => SavedGame.fromJson(jsonStr)).toList();
  }

  static Future<void> deleteGame(String gameId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedGames = await getSavedGames();
    savedGames.removeWhere((g) => g.id == gameId);
    final gamesJson = savedGames.map((g) => g.toJson()).toList();
    await prefs.setStringList(_savedGamesKey, gamesJson);
  }

  static String generateGameId() =>
      DateTime.now().millisecondsSinceEpoch.toString();
}

// ----------------------
// Splash Page
// ----------------------
class SplashPage extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage(
      {super.key, required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => goToPage),
      );
    });

    return const Scaffold(
      body: ColoredBox(
        color: Color.fromARGB(255, 0, 48, 73),
        child: Center(
          child: Icon(
            Icons.flag,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }
}

// ----------------------
// Home Screen
// ----------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SavedGame> savedGames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGames();
  }

  Future<void> _loadSavedGames() async {
    setState(() => isLoading = true);
    final games = await GameService.getSavedGames();
    setState(() {
      savedGames = games;
      isLoading = false;
    });
  }

  Future<void> _createNewGame() async {
    final newGame = SavedGame(
      id: GameService.generateGameId(),
      name: 'Game ${savedGames.length + 1}',
      savedDate: DateTime.now(),
      gameState: {'level': 1, 'resources': 1000, 'corruption': 10, 'popularity': 50},
      score: 0,
    );
    await GameService.saveGame(newGame);
    await _loadSavedGames();
  }

  void _loadGame(SavedGame game) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading "${game.name}"...'),
        backgroundColor: const Color.fromARGB(255, 0, 48, 73),
      ),
    );
    print('Game state: ${game.gameState}');
  }

  void _showSavedGamesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Saved Games', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 48, 73)))
              : savedGames.isEmpty
                  ? const Text('No saved games found.',
                      style: TextStyle(color: Colors.white))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: savedGames.map((game) {
                        return ListTile(
                          title: Text(game.name,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text('Score: ${game.score}',
                              style:
                                  const TextStyle(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_arrow,
                                    color: Colors.green),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _loadGame(game);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () async {
                                  await GameService.deleteGame(game.id);
                                  await _loadSavedGames();
                                  if (savedGames.isEmpty) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The State of Secret')),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StoryScreen()),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 0, 48, 73),
                    padding: const EdgeInsets.all(20)),
                child: const Text('Begin New Game',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventPage(event: getFelderEvent()),
                    ),
                  );
                },
                child: const Text('View Felder Event'),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _showSavedGamesDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        color: const Color.fromARGB(255, 0, 48, 73),
                        width: 4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.save,
                          color: Color.fromARGB(255, 0, 48, 73)),
                      const SizedBox(width: 10),
                      const Text('Saved Games',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 48, 73),
                              fontWeight: FontWeight.bold)),
                      if (savedGames.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 48, 73),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            savedGames.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Event & Character Setup

final Character felder = Character(
  name: "Felder",
  portrait: "assets/images/portrait1.png",
);

Event getFelderEvent() {
  return Event(
    id: 1,
    character: felder,
    background: "assets/images/courtroom1.png",
    date: 1,
    title: "Felder's Introduction",
    color: 0xFFC1121F,  
    dialogue: [
      "Oh, and if you find yourself slaying",
      "some of the bad, I'd happily take any",
      "pelts, bones, or other monster parts",
      "they leave behind! Haha!",
    ],
  );

}
