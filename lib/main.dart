import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'character.dart';
import 'event.dart';
import 'event_page.dart';
import 'decision.dart';
import 'decision_prompt.dart'; 

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

// In your game_data.dart
Decision getFelderDecision() {
  return Decision(
    id: 1,
    question: "How will you respond to Felder's offer?",
    options: [
      DecisionOption(
        id: 1,
        text: "Agree to collect monster parts for him",
        effect: "gain_trust+10",
      ),
      DecisionOption(
        id: 2,
        text: "Decline politely",
        effect: "neutral",
      ),
      DecisionOption(
        id: 3,
        text: "Ask for payment upfront",
        effect: "gain_wealth+50",
      ),
      DecisionOption(
        id: 4,
        text: "Threaten to report him",
        effect: "lose_trust-15",
      ),
    ],
  );
}

Event getFelderEvent() {
  return Event(
    id: 1,
    character: felder,
    background: 'assets/images/courtroom1.png',
    dialogue: [
      "Oh, and if you find yourself slaying",
      "some of the bad, I'd happily take any",
      "pelts, bones, or other monster parts",
      "they leave behind! Haha!",
    ],
    date: 1,
    title: "The Hunter's Offer",
    decision: getFelderDecision(),
    color: 0xFF780000,  // Add the decision here
  );
}
