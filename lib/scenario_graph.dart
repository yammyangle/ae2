// scenario_graph.dart

class ScenarioNode {
  final String id;
  final String title;
  final String description;
  final List<ScenarioChoice> choices;

  const ScenarioNode({
    required this.id,
    required this.title,
    required this.description,
    required this.choices,
  });
}

class ScenarioChoice {
  final String text;
  final String nextId;
  final List<ScenarioEffect> effects;

  const ScenarioChoice({
    required this.text,
    required this.nextId,
    required this.effects,
  });
}

class ScenarioEffect {
  final String stat;   // e.g. "publicTrust"
  final int value;     // e.g. +10, -20, etc.

  const ScenarioEffect({
    required this.stat,
    required this.value,
  });
}

/// Your whole JSON story, but as Dart constants:
class ScenarioGraph {
  static const Map<String, ScenarioNode> nodes = {
    "start": ScenarioNode(
      id: "start",
      title: "Victory Speech",
      description:
          "You have just won the election for Governor of Borno State on a platform of liberal reform: free schooling, lower taxes, and better infrastructure. The crowd is cheering. Your first day in office begins now.",
      choices: [
        ScenarioChoice(
          text: "Assume Office",
          nextId: "node_1",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: 10, // was add 10
            ),
          ],
        ),
      ],
    ),

    "node_1": ScenarioNode(
      id: "node_1",
      title: "Decision 1: The Campaign Debt",
      description:
          "Your campaign manager approaches you nervously. 'Governor, we still owe 50 million Naira to the godfathers who supported your run. They expect to be paid back immediately.'",
      choices: [
        ScenarioChoice(
          text: "Refuse to pay (Honor integrity)",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 10, // add 10
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: -20, // subtract 20
            ),
          ],
        ),
        ScenarioChoice(
          text: "Pay from government budget (Embezzlement)",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 15, // add 15
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -5, // subtract 5
            ),
          ],
        ),
        ScenarioChoice(
          text: "Give them government contracts (Nepotism)",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10, // add 10
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -10, // subtract 10
            ),
          ],
        ),
        ScenarioChoice(
          text: "Pay from personal funds (Family Debt)",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: -50, // subtract 50
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 5, // add 5
            ),
          ],
        ),
      ],
    ),

    "node_2": ScenarioNode(
      id: "node_2",
      title: "Decision 2: The Education Budget",
      description:
          "You promised free schooling, but the treasury is empty. The party chairman suggests diverting funds from the rural infrastructure budget. 'The villagers don't vote as much as the city folk,' he argues.",
      choices: [
        ScenarioChoice(
          text: "Refuse and break promise (Honest failure)",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: -20, // subtract 20
            ),
          ],
        ),
        ScenarioChoice(
          text: "Divert funds (Fund Urban Schools)",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 5, // add 5
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -15, // subtract 15
            ),
          ],
        ),
        ScenarioChoice(
          text: "Accept 'donation' from private schools to drop policy",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: 20, // add 20
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10, // add 10
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -10, // subtract 10
            ),
          ],
        ),
      ],
    ),

    "node_3": ScenarioNode(
      id: "node_3",
      title: "Decision 3: The Infrastructure Contract",
      description:
          "A major road needs building. A local contractor offers you a 20% kickback if you award them the contract, but they are known for using cheap materials.",
      choices: [
        ScenarioChoice(
          text: "Award to local contractor (Take Kickback)",
          nextId: "node_4",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: 20, // add 20
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -25, // subtract 25
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 20, // add 20
            ),
          ],
        ),
        ScenarioChoice(
          text: "Award to international firm (Clean)",
          nextId: "node_4",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: -10, // subtract 10
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: 10, // add 10
            ),
          ],
        ),
      ],
    ),

    "node_4": ScenarioNode(
      id: "node_4",
      title: "Decision 4: Family Pressure",
      description:
          "Your cousin needs a job. He is unqualified, but your mother is begging you. 'He is family,' she says.",
      choices: [
        ScenarioChoice(
          text: "Give him a high-level job (Nepotism)",
          nextId: "node_5",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10, // add 10
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -5, // subtract 5
            ),
          ],
        ),
        ScenarioChoice(
          text: "Refuse entirely",
          nextId: "node_5",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: -5, // subtract 5
            ),
          ],
        ),
      ],
    ),

    "node_5": ScenarioNode(
      id: "node_5",
      title: "The Crisis",
      description:
          "Disaster strikes! Due to previous budget cuts and poor contracts, a major bridge has collapsed during rush hour.",
      choices: [
        ScenarioChoice(
          text: "Take Responsibility and Resign",
          nextId: "ending_resigned",
          effects: [],
        ),
        ScenarioChoice(
          text: "Blame the previous administration",
          nextId: "ending_survived",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 5, // add 5
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -10, // subtract 10
            ),
          ],
        ),
      ],
    ),

    "ending_resigned": ScenarioNode(
      id: "ending_resigned",
      title: "Ending: The Martyr",
      description:
          "You resigned to save your integrity. Your career is over, but you are remembered as one of the few honest leaders. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "start",
          effects: [
            // Stat resets now handled in code when nextId == "start"
          ],
        ),
      ],
    ),

    "ending_survived": ScenarioNode(
      id: "ending_survived",
      title: "Ending: The Pragmatic Survivor",
      description:
          "You survived the scandal, but at what cost? You are still Governor, but the people trust you less, and the corruption is growing. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "start",
          effects: [
            // Stat resets now handled in code when nextId == "start"
          ],
        ),
      ],
    ),
  };

  static ScenarioNode getNode(String id) => nodes[id]!;
}
