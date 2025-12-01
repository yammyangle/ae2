class Decision {
  final int id;
  final String question;
  final List<DecisionOption> options;
  final String? background; // Optional different background for decision screen

  const Decision({
    required this.id,
    required this.question,
    required this.options,
    this.background,
  });
}

class DecisionOption {
  final int id;
  final String text;
  final String effect; // Could be stat changes, next event ID, etc.

  const DecisionOption({
    required this.id,
    required this.text,
    required this.effect,
  });
}