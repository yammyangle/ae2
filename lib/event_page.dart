import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'character.dart';
import 'event.dart';
import 'decision_prompt.dart'; 
import 'decision.dart';
import 'stats_bar.dart'; 

class EventPage extends StatefulWidget {
  final Event event;

  const EventPage({super.key, required this.event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  static const double portraitSize = 150;

  int _currentLineIndex = 0;      // which dialogue line we're on
  int _visibleChars = 0;          // how many characters currently visible
  Timer? _typingTimer;
  bool _showDecision = false;
  double corruptionLevel = 0;
  double publicTrust = 50;
  double personalWealth = -50;
  double infrastructureQuality = 50;
  double politicalCapital = 50;


  String get _currentFullLine => widget.event.dialogue[_currentLineIndex];

  bool get _isTyping => _visibleChars < _currentFullLine.length;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _visibleChars = 0;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (_visibleChars < _currentFullLine.length) {
        setState(() {
          _visibleChars++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onTap() {
    if (_isTyping) {
      // Finish current line instantly
      setState(() {
        _visibleChars = _currentFullLine.length;
      });
      _typingTimer?.cancel();
    } else {
      // Move to next line if any
      if (_currentLineIndex < widget.event.dialogue.length - 1) {
        setState(() {
          _currentLineIndex++;
        });
        _startTyping();
      } else {
        // Dialogue finished, show decision if available
        if (widget.event.decision != null && !_showDecision) {
          setState(() {
            _showDecision = true;
          });
        } else {
          // No decision or decision completed - exit event
          Navigator.pop(context);
        }
      }
    }
  }

  void _onDecisionSelected(DecisionOption selectedOption) {
    // Handle the selected decision
    print('Selected option: ${selectedOption.text}');
    print('Effect: ${selectedOption.effect}');
    
    // You can pass this back to the parent or handle game state changes
    // For now, just close the event page
    Navigator.pop(context, selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final String displayedText = _currentFullLine.substring(
      0,
      _visibleChars.clamp(0, _currentFullLine.length),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF003049), // Deep blue background
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showDecision ? null : _onTap, // Disable tap when showing decision
        child: Column(
          children: [
            // TOP: BACKGROUND IMAGE + STATS BAR OVERLAY
            SizedBox(
              height: screenHeight * 0.55,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      _showDecision
                          ? widget.event.decision?.background ?? widget.event.background
                          : widget.event.background,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Stats bar overlaid at the top
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
                ],
              ),
            ),

            // BOTTOM: DIALOG BOX OR DECISION PROMPT
            if (_showDecision && widget.event.decision != null)
              DecisionPrompt(
                decision: widget.event.decision!,
                onOptionSelected: _onDecisionSelected,
              )
            else
              Container(
                height: screenHeight * 0.45,
                width: double.infinity,
                color: Color(widget.event.color), // Dark red outer frame
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF0D5), // Cream base
                    border: Border.all(
                      color: Color(widget.event.color),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ================= MAIN CONTENT =================
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ------- NAME BAR (FULL WIDTH) -------
                          Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(widget.event.color), // Bright red
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(widget.event.color), // Dark red
                                  width: 2,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: portraitSize + 7, // room for portrait
                              bottom: 2,
                            ),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.event.character.name,
                              style: GoogleFonts.pixelifySans(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFDF0D5), // Cream text
                                  shadows: [
                                    Shadow(
                                      color: Color(widget.event.color), // Dark red shadow
                                      offset: const Offset(2, 2),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ------- BODY TEXT (WITH PADDING) -------
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  displayedText,
                                  style: GoogleFonts.pixelifySans(
                                    textStyle: const TextStyle(
                                      fontSize: 25,
                                      height: 1.2,
                                      color: Color(0xFF003049), // Deep blue text
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ================= PORTRAIT =================
                      Positioned(
                        left: 0,
                        top: -portraitSize * 0.7, // hanging into the background
                        child: Container(
                          width: portraitSize,
                          height: portraitSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(widget.event.color), // Bright red border
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF780000).withOpacity(0.5), // Dark red shadow
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(3, 3),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(widget.event.character.portrait),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );






  }
}