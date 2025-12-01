import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'scenario_graph.dart';
import 'node_presentation.dart';
import 'decision.dart';
import 'decision_prompt.dart';
import 'stats_bar.dart';

enum StoryPhase { dayIntro, dialogue, decision }

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _ActiveStatEffect {
  final String stat;    // e.g. "publicTrust"
  final double value;   // e.g. 10.0
  final bool positive;  // true for +, false for -

  _ActiveStatEffect({
    required this.stat,
    required this.value,
    required this.positive,
  });
}
class _StoryScreenState extends State<StoryScreen> {
  static const double portraitSize = 150;

  // which node in the scenario graph we’re on
  String _currentNodeId = "start";
  StoryPhase _phase = StoryPhase.dayIntro;

  List<_ActiveStatEffect> _activeEffects = [];
  bool _effectsVisible = false;
  // NEW: global day counter
  int _currentDay = 1;

  // stats for StatsBar
  double corruptionLevel = 0;
  double publicTrust = 50;
  double personalWealth = -50;
  double infrastructureQuality = 50;
  double politicalCapital = 50;

  // typewriter
  Timer? _typingTimer;
  String _fullText = "";
  String _displayedText = "";
  int _charIndex = 0;
  bool _finishedTyping = false;

  ScenarioNode get _currentNode => ScenarioGraph.getNode(_currentNodeId);
  NodePresentation get _present => NodePresentationConfig.forId(_currentNodeId);

  @override
  void initState() {
    super.initState();
    _startDayIntroTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  // ───────────── TYPEWRITER HELPERS ─────────────

  void _startTyping(String text, {int speedMs = 35}) {
    _typingTimer?.cancel();
    setState(() {
      _fullText = text;
      _displayedText = "";
      _charIndex = 0;
      _finishedTyping = false;
    });

    _typingTimer = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
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
    // 🔥 use global day counter, NOT nodePresentation day
    final dayText = "Day $_currentDay in office...";
    _startTyping(dayText, speedMs: 45);
  }

  void _startDialogueTyping() {
    final text = _present.dialogueLines.join("\n");
    _startTyping(text, speedMs: 25);
  }

  // ───────────── FLOW CONTROL ─────────────

  void _onBackgroundTap() {
    if (_phase == StoryPhase.decision) return; // taps disabled during decision

    if (!_finishedTyping) {
      // Skip to end of current text
      _typingTimer?.cancel();
      setState(() {
        _displayedText = _fullText;
        _finishedTyping = true;
      });
      return;
    }

    // Finished typing → advance phase
    setState(() {
      if (_phase == StoryPhase.dayIntro) {
        _phase = StoryPhase.dialogue;
        _startDialogueTyping();
      } else if (_phase == StoryPhase.dialogue) {
        _phase = StoryPhase.decision;
      }
    });
  }

  void _onDecisionSelected(DecisionOption option) {
    final node = _currentNode;
    final ScenarioChoice choice = node.choices[option.id];

    // 1) Apply effects (update stats)
    for (final effect in choice.effects) {
      _applyEffect(effect);
    }

    // 2) Trigger bubbles for all those effects
    _triggerEffectBubbles(choice.effects);

    // 3) Stay on decision screen while bubbles are visible
    setState(() {
      _phase = StoryPhase.decision; // already in this phase, but explicit
    });

    // 4) After animation, move to next node & day intro
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;

      setState(() {
        if (choice.nextId == "start") {
          // Restart scenario if you want
          _currentDay = 1;
          corruptionLevel = 0;
          publicTrust = 50;
          personalWealth = -50;
          infrastructureQuality = 50;
          politicalCapital = 50;
        } else {
          _currentDay += 1;
        }

        _currentNodeId = choice.nextId;
        _phase = StoryPhase.dayIntro;
      });

      _startDayIntroTyping();
    });
  }

  void _applyEffect(ScenarioEffect e) {
    double apply(double current) {
      switch (e.operation) {
        case "add":
          return current + e.value;
        case "subtract":
          return current - e.value;
        case "set":
          return e.value;
        default:
          return current;
      }
    }

    setState(() {
      switch (e.stat) {
        case "corruptionLevel":
          corruptionLevel = apply(corruptionLevel);
          break;
        case "publicTrust":
          publicTrust = apply(publicTrust);
          break;
        case "personalWealth":
          personalWealth = apply(personalWealth);
          break;
        case "infrastructureQuality":
          infrastructureQuality = apply(infrastructureQuality);
          break;
        case "politicalCapital":
          politicalCapital = apply(politicalCapital);
          break;
      }
    });

    // ❌ DO NOT call bubble trigger here anymore
  }

void _triggerEffectBubbles(List<ScenarioEffect> effects) {
  // Build bubbles for all add/subtract effects
  final newEffects = <_ActiveStatEffect>[];

  for (final e in effects) {
    if (e.operation == "set" || e.value == 0) continue;

    final isPositive = (e.operation == "add" && e.value > 0) ||
        (e.operation == "subtract" && e.value < 0);

    final amount = e.value.abs();

    newEffects.add(
      _ActiveStatEffect(
        stat: e.stat,
        value: amount,
        positive: isPositive,
      ),
    );
  }

  if (newEffects.isEmpty) return;

  setState(() {
    _activeEffects = newEffects;
    _effectsVisible = true;
  });

  // Show them, then make them float & fade
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


  // convert ScenarioNode → your Decision model for DecisionPrompt
  Decision _decisionFromNode(ScenarioNode node) {
    final options = <DecisionOption>[];
    for (int i = 0; i < node.choices.length; i++) {
      final choice = node.choices[i];
      options.add(
        DecisionOption(
          id: i,             // important: id = index, so we can map back
          text: choice.text,
          effect: "",        // we use ScenarioEffect instead
        ),
      );
    }

    return Decision(
      id: 0,
      question: node.description,
      options: options,
      background: _present.background,
    );
  }

  // ───────────── BUILD UI ─────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final node = _currentNode;
    final decision = _decisionFromNode(node);

    // 🔥 SPECIAL CASE: DAY INTRO = FULL-BLANK SCREEN
    if (_phase == StoryPhase.dayIntro) {
      return Scaffold(
        backgroundColor: const Color(0xFF003049), // or black if you prefer
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onBackgroundTap,
          child: Center(
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
      );
    }

    // For dialogue + decision: use your normal layout style
    return Scaffold(
      backgroundColor: const Color(0xFF003049),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onBackgroundTap,
        child: Column(
          children: [
            // TOP: BACKGROUND + STATS BAR
            SizedBox(
              height: screenHeight * 0.55,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      _present.background,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Stats bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: StatsBar(
                      corruptionLevel: corruptionLevel,
                      publicTrust: publicTrust,
                      personalWealth: personalWealth,
                      infrastructureQuality: infrastructureQuality,
                      politicalCapital: politicalCapital,
                    ),
                  ),

                  // MULTIPLE floating bubbles under the bar
                  if (_activeEffects.isNotEmpty)
                    Positioned.fill(
                      child: Stack(
                        children: _activeEffects.map((effect) {
                          return Align(
                            alignment: _alignmentForStat(effect.stat),
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 4000),
                              offset: _effectsVisible
                                  ? const Offset(0, 0)
                                  : const Offset(0, -0.5), // float up
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: _effectsVisible ? 1.0 : 0.0, // fade
                                child: _buildEffectBubble(effect),
                              ),
                            ),
                          );
                        }).toList(),
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
    );
  }

  Widget _buildDialogueBox(double screenHeight) {
    return Container(
      height: screenHeight * 0.45,
      width: double.infinity,
      color: const Color(0xFF780000), // outer frame
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Color(0xFFFDF0D5), // beige base
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // MAIN CONTENT (matching your EventPage aesthetics)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME BAR
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC1121F), // Bright red
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF780000), // Dark red
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
                    _present.characterName,
                    style: GoogleFonts.pixelifySans(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFDF0D5), // Cream text
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

                // DIALOGUE TEXT (typewriter text)
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

            // PORTRAIT
            Positioned(
              left: 0,
              top: -portraitSize * 0.7,
              child: Container(
                width: portraitSize,
                height: portraitSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFC1121F),
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
                    image: AssetImage(_present.portrait),
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

  Alignment _alignmentForStat(String stat) {
    // y = -1 is top, +1 is bottom
    // We want these just UNDER the stats bar at the top, so around y = -0.3
    const double y = -0.3;

    switch (stat) {
      case "corruptionLevel":
        return const Alignment(-0.8, y);
      case "publicTrust":
        return const Alignment(-0.4, y);
      case "personalWealth":
        return const Alignment(0.0, y);
      case "infrastructureQuality":
        return const Alignment(0.4, y);
      case "politicalCapital":
        return const Alignment(0.8, y);
      default:
        return Alignment(0.0, y);
    }
  }


Widget _buildEffectBubble(_ActiveStatEffect effect) {
  final sign = effect.positive ? "+" : "-";
  final color = effect.positive
      ? const Color(0xFF2ECC71) // green
      : const Color(0xFFE74C3C); // red

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

}
