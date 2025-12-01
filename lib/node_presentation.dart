// node_presentation.dart

class NodePresentation {
  final int dayNumber;
  final String characterName;
  final String portrait;
  final String background;
  final List<String> dialogueLines;

  const NodePresentation({
    required this.dayNumber,
    required this.characterName,
    required this.portrait,
    required this.background,
    required this.dialogueLines,
  });
}

// You can tweak these per node however you like.
class NodePresentationConfig {
  static const Map<String, NodePresentation> data = {
    "start": NodePresentation(
      dayNumber: 1,
      characterName: "Party Chairman",
      portrait: "assets/images/portraits/chairman.png",
      background: "assets/images/courtroom1.png",
      dialogueLines: [
        "Congratulations, Governor!",
        "The people have placed their trust in you.",
        "But you must know… the real work begins now."
      ],
    ),

    "node_1": NodePresentation(
      dayNumber: 5,
      characterName: "Campaign Manager",
      portrait: "assets/images/portraits/manager.png",
      background: "assets/images/campaign_office.png",
      dialogueLines: [
        "Governor, we have a problem.",
        "Those 'godfathers' who funded your campaign?",
        "They want their money back. Immediately."
      ],
    ),

    "node_2": NodePresentation(
      dayNumber: 30,
      characterName: "Finance Commissioner",
      portrait: "assets/images/portraits/finance.png",
      background: "assets/images/office_budget.png",
      dialogueLines: [
        "Sir, the treasury is dry.",
        "We can't fund both free schooling and rural roads.",
      ],
    ),

    // ...add entries for node_3, node_4, node_5, endings, etc.
  };

  static NodePresentation forId(String id) {
    return data[id] ??
        const NodePresentation(
          dayNumber: 1,
          characterName: "Advisor",
          portrait: "assets/images/portraits/default.png",
          background: "assets/images/courtroom1.png",
          dialogueLines: [
            "No custom dialogue defined for this situation yet.",
          ],
        );
  }
}
