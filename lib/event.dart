import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// event.dart
import 'character.dart';

class Event {
  final Character character;
  final List<String> dialogue;
  final String background;   // new

  Event({
    required this.character,
    required this.dialogue,
    required this.background,
  });
}


