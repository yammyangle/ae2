import 'dart:convert';
import 'package:ae2/instruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'story_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'character.dart';
import 'event.dart';
import 'event_page.dart';
import 'pixel_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(
        duration: 2,
        goToPage: const HomeScreen(),
      ),
    ));
  });
}

// Saved Game Model & Service

class SavedGame {
  final String id;
  final String name;
  final DateTime savedDate;
  final Map<String, dynamic> gameState;
  final int currentDay;

  SavedGame({
    required this.id,
    required this.name,
    required this.savedDate,
    required this.gameState,
    required this.currentDay,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'savedDate': savedDate.toIso8601String(),
        'gameState': gameState,
        'currentDay': currentDay,
      };

  factory SavedGame.fromMap(Map<String, dynamic> map) => SavedGame(
        id: map['id'],
        name: map['name'],
        savedDate: DateTime.parse(map['savedDate']),
        gameState: Map<String, dynamic>.from(map['gameState']),
        currentDay: map['currentDay'] ?? 1,
      );

  String toJson() => json.encode(toMap());
  factory SavedGame.fromJson(String source) =>
      SavedGame.fromMap(json.decode(source));
}

class GameService {
  static const String _savedGamesKey = 'saved_games';
  static const String _gameCounterKey = 'game_counter';

  static Future<String> getNextGameName() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(_gameCounterKey) ?? 0;
    counter++;
    await prefs.setInt(_gameCounterKey, counter);
    return 'Game $counter';
  }

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

// Splash Page

class SplashPage extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage({super.key, required this.goToPage, required this.duration});

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

// Home Screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SavedGame> savedGames = [];
  bool isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadSavedGames();
    _playMenuMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playMenuMusic() {
    _audioPlayer.play(AssetSource('audio/cheering.wav'));
  }

  Future<void> _loadSavedGames() async {
    setState(() => isLoading = true);
    final games = await GameService.getSavedGames();
    setState(() {
      savedGames = games;
      isLoading = false;
    });
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
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: savedGames.length,
                      itemBuilder: (context, index) {
                        final game = savedGames[index];
                        return Card(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          child: ListTile(
                            title: Text(game.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Day ${game.currentDay} • Saved: ${_formatDate(game.savedDate)}',
                                style: const TextStyle(color: Colors.white70)),
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
                                    Navigator.pop(context);
                                    _showSavedGamesDialog();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _loadGame(SavedGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryScreen(
          savedGame: game,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/victory.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Begin New Game Button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VictorySpeechScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 48, 73),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Begin New Game',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),

                // How to Play Button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InstructionsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(230, 255, 255, 255),
                      border: Border.all(
                          color: const Color.fromARGB(255, 0, 48, 73),
                          width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.help_outline,
                            color: Color.fromARGB(255, 0, 48, 73)),
                        SizedBox(width: 10),
                        Text('How to Play',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 48, 73),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Saved Games Button
                InkWell(
                  onTap: _showSavedGamesDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      border: Border.all(
                          color: const Color.fromARGB(255, 0, 48, 73),
                          width: 4),
                      borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}

//  Speech Screen

class VictorySpeechScreen extends StatefulWidget {
  const VictorySpeechScreen({super.key});

  @override
  State<VictorySpeechScreen> createState() => _VictorySpeechScreenState();
}

class _VictorySpeechScreenState extends State<VictorySpeechScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/victory.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Victory Speech',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 48, 73),
                        width: 3,
                      ),
                    ),
                    child: const Text(
                      'You have just won the election for Governor of Borno State on a platform of liberal reform: free schooling, lower taxes, and better infrastructure.\n\nThe crowd is cheering.\n\nYour first day in office begins now.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoryScreen(startAtNode: 'node_1'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 48, 73),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Assume Office',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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