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
  final String stat;
  final int value;

  const ScenarioEffect({
    required this.stat,
    required this.value,
  });
}

class ScenarioGraph {
  static const Map<String, ScenarioNode> nodes = {
    "start": ScenarioNode(
      id: "start",
      title: "Victory Speech",
      description: "You have just won the election for Governor of Borno State.",
      choices: [
        ScenarioChoice(
          text: "Assume Office",
          nextId: "node_1",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: 10,
            ),
          ],
        ),
      ],
    ),

    "node_1": ScenarioNode(
      id: "node_1",
      title: "Decision 1: The Campaign Debt",
      description: "So, Your Excellency, how do you want to handle this?",
      choices: [
        ScenarioChoice(
          text: "I won't be extorted. Let them try whatever they want.",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 20,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: -40,
            ),
          ],
        ),
        ScenarioChoice(
          text: "The Ministry of Works has some discretionary funds we could redirect temporarily. Infrastructure projects can wait a few months.",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -15,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 10,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -5,
            ),
          ],
        ),
        ScenarioChoice(
          text: "What if we brought them into the administration? Key positions where they can... benefit legitimately.",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 15,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -20,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 20,
            ),
          ],
        ),
        ScenarioChoice(
          text: "I'll pay them back myself, from my salary. Set up an installment plan.",
          nextId: "node_2",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 10,
            ),
            ScenarioEffect(
              stat: "personalWealth",
              value: -30,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: -10,
            ),
          ],
        ),
      ],
    ),

    "node_2": ScenarioNode(
      id: "node_2",
      title: "Decision 2: The Education Budget",
      description: "What's it going to be, Your Excellency?",
      choices: [
        ScenarioChoice(
          text: "I won't break my promise to the people, but I won't steal from rural communities either. We'll announce a phased implementation.",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: -20,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Reallocate the rural infrastructure funds. We'll prioritize urban schools first and expand to rural areas next year.",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 5,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -15,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Arrange a meeting with the private school association. If their proposal benefits the state, I should at least hear them out.",
          nextId: "node_3",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: 20,
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -10,
            ),
          ],
        ),
      ],
    ),

    "node_3": ScenarioNode(
      id: "node_3",
      title: "Decision 3: The Infrastructure Contract",
      description: "The decision is yours, Governor.",
      choices: [
        ScenarioChoice(
          text: "Award it to Alhaji Bello. Take the kickback.",
          nextId: "node_4",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: 20,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -25,
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 20,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Award it to the international firm. No kickbacks.",
          nextId: "node_4",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: -10,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: 10,
            ),
          ],
        ),
      ],
    ),

    "node_4": ScenarioNode(
      id: "node_4",
      title: "Decision 4: Family Pressure",
      description: "What will you tell your cousin?",
      choices: [
        ScenarioChoice(
          text: "Give him a high-level position. Head of Licensing.",
          nextId: "node_5",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10,
            ),
            ScenarioEffect(
              stat: "infrastructureQuality",
              value: -5,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 5,
            ),
          ],
        ),
        ScenarioChoice(
          text: "I'll give him a low-level position he can actually handle.",
          nextId: "node_5",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: -5,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: 5,
            ),
          ],
        ),
        ScenarioChoice(
          text: "I can't give him a government job, Mama. It wouldn't be right.",
          nextId: "node_5",
          effects: [
            ScenarioEffect(
              stat: "politicalCapital",
              value: -10,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: 10,
            ),
          ],
        ),
      ],
    ),

    "node_5": ScenarioNode(
      id: "node_5",
      title: "Decision 5: The Journalist",
      description: "This could end your career. What do you want to do?",
      choices: [
        ScenarioChoice(
          text: "Confess everything. Schedule a press conference.",
          nextId: "ending_whistleblower",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 30,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: -50,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Offer her money. Everyone has a price.",
          nextId: "node_6_check", // Check if bridge should collapse
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: -20,
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 20,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Have her... dealt with. Make the story go away.",
          nextId: "node_6_check", // Check if bridge should collapse
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 30,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -30,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Work with her. Expose the whole corrupt system.",
          nextId: "ending_whistleblower",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 20,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: -40,
            ),
          ],
        ),
      ],
    ),

    // This node checks if infrastructure is bad enough for bridge collapse
    "node_6_check": ScenarioNode(
      id: "node_6_check",
      title: "Months Pass...",
      description: "Time will tell the consequences of your choices.",
      choices: [
        ScenarioChoice(
          text: "Continue...",
          nextId: "node_6", // Will be handled by story_screen logic
          effects: [],
        ),
      ],
    ),

    "node_6": ScenarioNode(
      id: "node_6",
      title: "Decision 6: The Crisis - Bridge Collapse",
      description: "The press conference is in one hour. What will you say?",
      choices: [
        ScenarioChoice(
          text: "Take full responsibility. Resign immediately.",
          nextId: "ending_martyr",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 20,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Blame the previous administration and the contractor.",
          nextId: "ending_survivor",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 5,
            ),
            ScenarioEffect(
              stat: "publicTrust",
              value: -10,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 5,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Cover it up. Pay off the families quietly.",
          nextId: "ending_corruptor",
          effects: [
            ScenarioEffect(
              stat: "personalWealth",
              value: -30,
            ),
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 20,
            ),
          ],
        ),
      ],
    ),

    // Alternative node_6 for clean infrastructure path
    "node_6_clean": ScenarioNode(
      id: "node_6_clean",
      title: "Decision 6: Economic Pressure",
      description: "Your term is coming to an end. The party wants answers about your performance.",
      choices: [
        ScenarioChoice(
          text: "Stand by my record. I kept my integrity.",
          nextId: "ending_reformer",
          effects: [
            ScenarioEffect(
              stat: "publicTrust",
              value: 10,
            ),
          ],
        ),
        ScenarioChoice(
          text: "Make compromises now to secure re-election.",
          nextId: "ending_survivor",
          effects: [
            ScenarioEffect(
              stat: "corruptionLevel",
              value: 10,
            ),
            ScenarioEffect(
              stat: "politicalCapital",
              value: 20,
            ),
          ],
        ),
      ],
    ),

    "ending_martyr": ScenarioNode(
      id: "ending_martyr",
      title: "Ending: The Martyr",
      description: "You resigned to save your integrity. Your career is over, but you are remembered as one of the few honest leaders. History will remember your sacrifice. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "node_1",
          effects: [],
        ),
      ],
    ),

    "ending_survivor": ScenarioNode(
      id: "ending_survivor",
      title: "Ending: The Pragmatic Survivor",
      description: "You survived the scandal, but at what cost? You are still Governor, but the people trust you less. The corruption is growing, and your conscience weighs heavy. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "node_1",
          effects: [],
        ),
      ],
    ),

    "ending_corruptor": ScenarioNode(
      id: "ending_corruptor",
      title: "Ending: The Comfortable Corruptor",
      description: "You're wealthy, your family is secure. But infrastructure is failing, schools are closed, and people are suffering. You live in your mansion, but the guilt never leaves. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "node_1",
          effects: [],
        ),
      ],
    ),

    "ending_whistleblower": ScenarioNode(
      id: "ending_whistleblower",
      title: "Ending: The Whistleblower",
      description: "You exposed the corruption, but your career is destroyed. Your family faces threats. Yet you triggered real investigations. Reform is possible. You paid the price for truth. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "node_1",
          effects: [],
        ),
      ],
    ),

    "ending_reformer": ScenarioNode(
      id: "ending_reformer",
      title: "Ending: The Reformer",
      description: "You took the hard path. You stayed clean and still made progress. It wasn't easy, and you made sacrifices. But change is possible. You proved it can be done. GAME OVER.",
      choices: [
        ScenarioChoice(
          text: "Play Again",
          nextId: "node_1",
          effects: [],
        ),
      ],
    ),
  };

  static ScenarioNode getNode(String id) => nodes[id]!;
}