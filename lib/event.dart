// event.dart
import 'character.dart';
import 'decision.dart';

class Event {
  final int id;
  final Character character;
  final String background;
  final List<String> dialogue;
  final String? sound;
  final int date;
  final String title;
  final Decision? decision; 
  final int color;// Add decision to event

  const Event({
    required this.id,
    required this.character,
    required this.background,
    required this.dialogue,
    this.sound,
    required this.date,
    required this.title,
    this.decision,
    required this.color,
  });
}