import 'dart:async';

import 'package:ae2/pixel_adventure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

import 'scenario_graph.dart';
import 'node_presentation.dart';
import 'decision.dart';
import 'decision_prompt.dart';
import 'stats_bar.dart';
import 'dart:math'; 
import 'package:flutter/services.dart';
import 'main.dart'; // Import to access SavedGame and GameService

enum StoryPhase { dayIntro, dialogue, decision }

enum StatType {
  corruptionLevel,
  publicTrust,
  personalWealth,
  infrastructureQuality,
  politicalCapital,
}

class StoryScreen extends StatefulWidget {
  final SavedGame? savedGame;
  final String? startAtNode;

  const StoryScreen({super.key, this.savedGame, this.startAtNode});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _ActiveStatEffect {
  final StatType stat;
  final double value;
  final bool positive;

  _ActiveStatEffect({
    required this.stat,
    required this.value,
    required this.positive,
  });
}

class _StoryCheckpoint {
  final String nodeId;
  final int day;
  final double corruptionLevel;
  final double publicTrust;
  final double personalWealth;
  final double infrastructureQuality;
  final double politicalCapital;

  const _StoryCheckpoint({
    required this.nodeId,
    required this.day,
    required this.corruptionLevel,
    required this.publicTrust,
    required this.personalWealth,
    required this.infrastructureQuality,
    required this.politicalCapital,
  });
}

// History state for back button
class _HistoryState {
  final String nodeId;
  final int beatIndex;
  final int lineIndex;
  final StoryPhase phase;
  final double corruptionLevel;
  final double publicTrust;
  final double personalWealth;
  final double infrastructureQuality;
  final double politicalCapital;

  _HistoryState({
    required this.nodeId,
    required this.beatIndex,
    required this.lineIndex,
    required this.phase,
    required this.corruptionLevel,
    required this.publicTrust,
    required this.personalWealth,
    required this.infrastructureQuality,
    required this.politicalCapital,
  });
}

class _StoryScreenState extends State<StoryScreen> {
  static const double portraitSize = 150;
  static const double minStatValue = -100;
  static const double maxStatValue = 100;

  // Save/Load related
  String? currentGameId;
  String? currentGameName;

  String _currentNodeId = "start";
  StoryPhase _phase = StoryPhase.dayIntro;
  int _currentBeatIndex = 0;
  int _currentLineIndex = 0;

  List<_ActiveStatEffect> _activeEffects = [];
  bool _effectsVisible = false;
  int _currentDay = 1;

  double corruptionLevel = 0;
  double publicTrust = 50;
  double personalWealth = -50;
  double infrastructureQuality = 50;
  double politicalCapital = 50;

  Timer? _typingTimer;
  String _fullText = "";
  String _displayedText = "";
  int _charIndex = 0;
  bool _finishedTyping = false;

  // History for back button
  final List<_HistoryState> _history = [];
  bool get _isEnding => _currentNodeId.startsWith('ending_');
  
  final AudioPlayer _audioPlayer = AudioPlayer();

  ScenarioNode get _currentNode => ScenarioGraph.getNode(_currentNodeId);
  NodePresentation get _present => NodePresentationConfig.forId(_currentNodeId);
  
  DialogueBeat get _currentBeat => _present.beats[_currentBeatIndex];

  @override
  void initState() {
    super.initState();
    
    // Lock to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Load saved game if provided
    if (widget.savedGame != null) {
      _loadGameState(widget.savedGame!);
    } else if (widget.startAtNode != null) {
      // Start at a specific node (e.g., 'node_1' after victory speech)
      _currentNodeId = widget.startAtNode!;
    }

    // START THE ORIGINAL STORY TYPING
    _startDayIntroTyping();

    // RANDOM KIDNAPPING ALERT
    final randomDelay = Duration(seconds: 30 + Random().nextInt(15));
    Future.delayed(randomDelay, () {
      if (mounted) _showKidnappingAlert();
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ───────────── SAVE/LOAD FUNCTIONS ─────────────

  void _loadGameState(SavedGame game) {
    currentGameId = game.id;
    currentGameName = game.name;
    _currentDay = game.currentDay;
    _currentNodeId = game.gameState['currentNodeId'] ?? 'start';
    
    // Load stats
    corruptionLevel = game.gameState['corruptionLevel']?.toDouble() ?? 0;
    publicTrust = game.gameState['publicTrust']?.toDouble() ?? 50;
    personalWealth = game.gameState['personalWealth']?.toDouble() ?? -50;
    infrastructureQuality = game.gameState['infrastructureQuality']?.toDouble() ?? 50;
    politicalCapital = game.gameState['politicalCapital']?.toDouble() ?? 50;
  }

  Future<void> _saveGame() async {
    try {
      // If this is a new game, generate ID and name
      if (currentGameId == null) {
        currentGameId = GameService.generateGameId();
        currentGameName = await GameService.getNextGameName();
      }

      // Collect all game state
      final gameState = {
        'currentNodeId': _currentNodeId,
        'corruptionLevel': corruptionLevel,
        'publicTrust': publicTrust,
        'personalWealth': personalWealth,
        'infrastructureQuality': infrastructureQuality,
        'politicalCapital': politicalCapital,
      };

      final savedGame = SavedGame(
        id: currentGameId!,
        name: currentGameName!,
        savedDate: DateTime.now(),
        gameState: gameState,
        currentDay: _currentDay,
      );

      await GameService.saveGame(savedGame);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Game saved as $currentGameName!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save game'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveCurrentState() {
    _history.add(_HistoryState(
      nodeId: _currentNodeId,
      beatIndex: _currentBeatIndex,
      lineIndex: _currentLineIndex,
      phase: _phase,
      corruptionLevel: corruptionLevel,
      publicTrust: publicTrust,
      personalWealth: personalWealth,
      infrastructureQuality: infrastructureQuality,
      politicalCapital: politicalCapital,
    ));
  }

  void _goBack() {
    if (_history.isEmpty) return;

    final previousState = _history.removeLast();
    
    setState(() {
      _currentNodeId = previousState.nodeId;
      _currentBeatIndex = previousState.beatIndex;
      _currentLineIndex = previousState.lineIndex;
      _phase = previousState.phase;
      corruptionLevel = previousState.corruptionLevel;
      publicTrust = previousState.publicTrust;
      personalWealth = previousState.personalWealth;
      infrastructureQuality = previousState.infrastructureQuality;
      politicalCapital = previousState.politicalCapital;
    });

    if (_phase == StoryPhase.dayIntro) {
      _startDayIntroTyping();
    } else if (_phase == StoryPhase.dialogue) {
      _startCurrentLineTyping();
    }
  }

  void _startTyping(String text, {int speedMs = 35}) {
    _typingTimer?.cancel();
    setState(() {
      _fullText = text;
      _displayedText = "";
      _charIndex = 0;
      _finishedTyping = false;
    });

    _typingTimer = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_charIndex >= _fullText.length) {
        timer.cancel();
        setState(() {
          _finishedTyping = true;
        });
      } else {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      }
    });
  }

  void _startDayIntroTyping() {
    final dayText = "Day ${_present.dayNumber} in office...";
    _startTyping(dayText, speedMs: 45);
    
    // Play day transition sound
    _audioPlayer.play(AssetSource('audio/transition.wav'));
  }

  void _startCurrentLineTyping() {
    final line = _currentBeat.lines[_currentLineIndex];
    _startTyping(line, speedMs: 25);
  }

  _ActiveStatEffect? _effectForStat(StatType statType) {
    try {
      return _activeEffects.firstWhere((effect) => effect.stat == statType);
    } catch (e) {
      return null;
    }
  }

  void _updateStat(StatType statType, int change) {
    setState(() {
      switch (statType) {
        case StatType.corruptionLevel:
          corruptionLevel = _clampValue(corruptionLevel + change);
          break;
        case StatType.publicTrust:
          publicTrust = _clampValue(publicTrust + change);
          break;
        case StatType.personalWealth:
          personalWealth = _clampValue(personalWealth + change);
          break;
        case StatType.infrastructureQuality:
          infrastructureQuality = _clampValue(infrastructureQuality + change);
          break;
        case StatType.politicalCapital:
          politicalCapital = _clampValue(politicalCapital + change);
          break;
      }
    });
  }

  double _clampValue(double value) {
    return value.clamp(minStatValue, maxStatValue);
  }

  StatType _stringToStatType(String statString) {
    switch (statString) {
      case "corruptionLevel":
        return StatType.corruptionLevel;
      case "publicTrust":
        return StatType.publicTrust;
      case "personalWealth":
        return StatType.personalWealth;
      case "infrastructureQuality":
        return StatType.infrastructureQuality;
      case "politicalCapital":
        return StatType.politicalCapital;
      default:
        debugPrint("Unknown stat string: $statString");
        return StatType.publicTrust;
    }
  }

  void _onBackgroundTap() {
    if (_phase == StoryPhase.decision) return;

    if (!_finishedTyping) {
      _typingTimer?.cancel();
      setState(() {
        _displayedText = _fullText;
        _finishedTyping = true;
      });
      return;
    }

    if (_phase == StoryPhase.dayIntro) {
      // Save state before moving to dialogue
      _saveCurrentState();
      
      setState(() {
        _phase = StoryPhase.dialogue;
        _currentBeatIndex = 0;
        _currentLineIndex = 0;
      });
      _startCurrentLineTyping();
      return;
    }

    if (_phase == StoryPhase.dialogue) {
      // Check if there are more lines in current beat
      if (_currentLineIndex < _currentBeat.lines.length - 1) {
        // Save state before moving to next line
        _saveCurrentState();
        
        setState(() {
          _currentLineIndex++;
        });
        _startCurrentLineTyping();
        return;
      }

      // Check if there are more beats
      if (_currentBeatIndex < _present.beats.length - 1) {
        // Save state before moving to next beat
        _saveCurrentState();
        
        setState(() {
          _currentBeatIndex++;
          _currentLineIndex = 0;
        });
        _startCurrentLineTyping();
        return;
      }

      // All dialogue done, move to decision
      _saveCurrentState();
      
      setState(() {
        _phase = StoryPhase.decision;
      });
    }
  }

  void _onDecisionSelected(DecisionOption option) {
    final node = _currentNode;
    final ScenarioChoice choice = node.choices[option.id];

    _triggerEffectBubbles(choice.effects);

    setState(() {
      _phase = StoryPhase.decision;
    });

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;

      setState(() {
        if (choice.nextId == "start") {
          _currentDay = 1;
          corruptionLevel = 0;
          publicTrust = 50;
          personalWealth = -50;
          infrastructureQuality = 50;
          politicalCapital = 50;
          _history.clear(); // Clear history on restart
          currentGameId = null;
          currentGameName = null;
        } else {
          _currentDay += 1;
        }

        String nextNode = choice.nextId;
        if (nextNode == "node_6_check") {
          if (infrastructureQuality < 20) {
            nextNode = "node_6";
          } else {
            nextNode = "node_6_clean";
          }
        }

        _currentNodeId = nextNode;
        _phase = StoryPhase.dayIntro;
        _currentBeatIndex = 0;
        _currentLineIndex = 0;
      });

      _startDayIntroTyping();
      
      // Auto-save after each decision
      _saveGame();
    });
  }

  void _triggerEffectBubbles(List<ScenarioEffect> effects) {
    if (effects.isEmpty) return;

    final newEffects = <_ActiveStatEffect>[];

    setState(() {
      for (final e in effects) {
        final statType = _stringToStatType(e.stat);
        
        _updateStat(statType, e.value);

        if (e.value != 0) {
          newEffects.add(
            _ActiveStatEffect(
              stat: statType,
              value: e.value.abs().toDouble(),
              positive: e.value > 0,
            ),
          );
        }
      }

      _activeEffects = newEffects;
      _effectsVisible = newEffects.isNotEmpty;
    });

    if (newEffects.isEmpty) return;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _effectsVisible = false;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _activeEffects = [];
        });
      });
    });
  }

  Decision _decisionFromNode(ScenarioNode node) {
    final options = <DecisionOption>[];
    for (int i = 0; i < node.choices.length; i++) {
      final choice = node.choices[i];
      options.add(
        DecisionOption(
          id: i,
          text: choice.text,
          effect: "",
        ),
      );
    }

    return Decision(
      id: 0,
      question: node.description,
      options: options,
      background: _currentBeat.background,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final node = _currentNode;
    final decision = _decisionFromNode(node);

    if (_phase == StoryPhase.dayIntro) {
      return Scaffold(
        backgroundColor: const Color(0xFF003049),
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onBackgroundTap,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _displayedText,
                    style: GoogleFonts.pixelifySans(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFDF0D5),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            if (_history.isNotEmpty)
              Positioned(
                bottom: 40,
                left: 10,
                child: _buildBackButton(),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF003049),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onBackgroundTap,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.55,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          _currentBeat.background,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StatsBar(
                              corruptionLevel: corruptionLevel,
                              publicTrust: publicTrust,
                              personalWealth: personalWealth,
                              infrastructureQuality: infrastructureQuality,
                              politicalCapital: politicalCapital,
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _buildEffectRow(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_phase == StoryPhase.dialogue)
                  _buildDialogueBox(screenHeight)
                else
                  DecisionPrompt(
                    decision: decision,
                    onOptionSelected: _onDecisionSelected,
                  ),
              ],
            ),
          ),
          // Back button overlay
          if (_history.isNotEmpty && _phase != StoryPhase.decision)
            Positioned(
              bottom: 40,
              left: 10,
              child: _buildBackButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _goBack,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF0D5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF003049),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF780000).withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            '<-',
            style: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003049),
                height: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogueBox(double screenHeight) {
    final beat = _currentBeat;
    
    // Check if this is an ending - use special styling
    if (_isEnding) {
      return _buildEndingBox(screenHeight, beat);
    }
    
    // Regular dialogue box
    final boxColor = Color(beat.color);
    
    return Container(
      height: screenHeight * 0.45,
      width: double.infinity,
      color: const Color(0xFF780000),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xFFFDF0D5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (beat.speaker.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: boxColor,
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xFF780000),
                          width: 2,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: portraitSize + 7,
                      bottom: 2,
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      beat.speaker,
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFDF0D5),
                          shadows: [
                            Shadow(
                              color: Color(0xFF780000),
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _displayedText,
                        style: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            height: 1.2,
                            color: Color(0xFF003049),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: -portraitSize * 0.7,
              child: Container(
                width: portraitSize,
                height: portraitSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: boxColor,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF780000).withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(3, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(beat.portrait),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndingBox(double screenHeight, DialogueBeat beat) {
    // Play ending audio
    _playEndingAudio();
    
    // Determine if this is a "good" or "bad" ending for color scheme
    final isGoodEnding = _currentNodeId == 'ending_reformer' || 
                         _currentNodeId == 'ending_whistleblower' || 
                         _currentNodeId == 'ending_martyr';
    
    final titleColor = isGoodEnding 
        ? const Color(0xFFFFD700)  // Gold for good endings
        : const Color(0xFFDC143C);  // Crimson for bad endings
    
    final textColor = isGoodEnding
        ? const Color(0xFFFDF0D5)  // Light cream for good endings
        : const Color(0xFFFFB6B6);  // Light red for bad endings
    
    return Container(
      height: screenHeight * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        border: Border.all(
          color: titleColor,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: titleColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Dramatic title banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGoodEnding
                    ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)]
                    : [const Color(0xFF1A0000), const Color(0xFF2D0000)],
              ),
              border: Border(
                bottom: BorderSide(
                  color: titleColor,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              beat.speaker,
              textAlign: TextAlign.center,
              style: GoogleFonts.pixelifySans(
                textStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: titleColor.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                    const Shadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Ending text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Text(
                  _displayedText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 20,
                      height: 1.4,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        const Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playEndingAudio() {
    final isGoodEnding = _currentNodeId == 'ending_reformer' || 
                         _currentNodeId == 'ending_whistleblower' || 
                         _currentNodeId == 'ending_martyr';
    
    final audioFile = isGoodEnding 
        ? 'audio/goodending1.wav' 
        : 'audio/badending.wav';
    
    _audioPlayer.play(AssetSource(audioFile));
  }

  Widget _buildEffectBubble(_ActiveStatEffect effect) {
    final sign = effect.positive ? "+" : "-";
    final color = effect.positive
        ? const Color(0xFF2ECC71)
        : const Color(0xFFE74C3C);

    final valueText = effect.value.toInt().toString();

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.7),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        "$sign$valueText",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  List<Widget> _buildEffectRow() {
    const statsOrder = [
      StatType.corruptionLevel,
      StatType.publicTrust,
      StatType.infrastructureQuality,
      StatType.politicalCapital,
      StatType.personalWealth,
    ];

    return statsOrder.map((stat) {
      final effect = _effectForStat(stat);

      if (effect == null) {
        return const SizedBox(
          width: 28,
          height: 28,
        );
      }

      return AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _effectsVisible
            ? Offset.zero
            : const Offset(0, -0.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _effectsVisible ? 1.0 : 0.0,
          child: _buildEffectBubble(effect),
        ),
      );
    }).toList();
  }

  // MINIGAME SUCCESS HANDLER
  void _handleMiniGameReturn(_StoryCheckpoint savedState) {
    print('🎊 STORY: _handleMiniGameReturn called!');
    print('🎊 STORY: Restoring state - node: ${savedState.nodeId}, day: ${savedState.day}');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🎉 ESCAPE SUCCESSFUL! 🎉",
                style: GoogleFonts.pixelifySans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "You've managed to escape the mafia's basement!\n\n"
                "The guard dog was distracted by the oranges.\n"
                "You return to your duties as Governor...",
                style: GoogleFonts.pixelifySans(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2ECC71),
                ),
                onPressed: () {
                  print('✅ STORY: Continue Story button pressed');
                  Navigator.of(context).pop();
                  print('✅ STORY: Success dialog closed');
                  
                  setState(() {
                    _currentNodeId = savedState.nodeId;
                    _currentDay = savedState.day;
                    corruptionLevel = savedState.corruptionLevel;
                    publicTrust = savedState.publicTrust;
                    personalWealth = savedState.personalWealth;
                    infrastructureQuality = savedState.infrastructureQuality;
                    politicalCapital = savedState.politicalCapital;
                    
                    publicTrust = _clampValue(publicTrust + 5);
                    politicalCapital = _clampValue(politicalCapital + 5);
                  });
                  
                  print('✅ STORY: State restored successfully!');
                },
                child: Text(
                  "CONTINUE STORY",
                  style: GoogleFonts.pixelifySans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showKidnappingAlert() async {
  final savedState = _StoryCheckpoint(
    nodeId: _currentNodeId,
    day: _currentDay,
    corruptionLevel: corruptionLevel,
    publicTrust: publicTrust,
    personalWealth: personalWealth,
    infrastructureQuality: infrastructureQuality,
    politicalCapital: politicalCapital,
  );

  // Play alert sound
  final alertPlayer = AudioPlayer();
  await alertPlayer.play(AssetSource('audio/alert.mp3'));

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5C8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF7A5633), width: 6),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(4, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "⚠️ ATTENTION ⚠️",
                style: GoogleFonts.pixelifySans(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E3A23),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "You have been KIDNAPPED by the local mafia!\n\n"
                "They are furious that you trespassed into their territory.\n"
                "They have locked you in their basement and placed a mask on you.\n\n"
                "You must collect ALL the oranges – the guard dog's favorite – "
                "to distract him and ESCAPE!",
                style: GoogleFonts.pixelifySans(
                  fontSize: 18,
                  height: 1.4,
                  color: const Color(0xFF4E3A23),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5633),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  alertPlayer.dispose();
                  
                  final completed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return PixelAdventureScreen(
                          onLevelComplete: () {
                            Navigator.of(context).pop(true);
                          },
                        );
                      },
                    ),
                  );

                  if (completed == true && mounted) {
                    _handleMiniGameReturn(savedState);
                  }
                },
                child: Text(
                  "CONTINUE",
                  style: GoogleFonts.pixelifySans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}