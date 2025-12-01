import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'character.dart';
import 'event.dart';
import 'event_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Events',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Events')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the Felder event
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(event: getFelderEvent()),
              ),
            );
          },
          child: const Text('View Felder Event'),
        ),
      ),
    );
  }
}

// Define characters
final Character felder = Character(
  name: "Felder",
  portrait: "assets/images/portrait1.png",
);

Event getFelderEvent() {
  return Event(
    character: felder,
    background: "assets/images/courtroom1.png",
    dialogue: [
      "Oh, and if you find yourself slaying",
      "some of the bad, I'd happily take any",
      "pelts, bones, or other monster parts",
      "they leave behind! Haha!",
    ],
  );
}
