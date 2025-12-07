// node_presentation.dart

class DialogueBeat {
  final String speaker;
  final List<String> lines;
  final String background;
  final String portrait;
  final int color;

  const DialogueBeat({
    required this.speaker,
    required this.lines,
    required this.background,
    required this.portrait,
    required this.color,
  });
}

class NodePresentation {
  final int dayNumber;
  final List<DialogueBeat> beats;

  const NodePresentation({
    required this.dayNumber,
    required this.beats,
  });
}

class NodePresentationConfig {
  static const Map<String, NodePresentation> data = {
    "start": NodePresentation(
      dayNumber: 0,
      beats: [
        DialogueBeat(
          speaker: "You",
          background: "assets/images/parade.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "I can't believe I've won the election for Governor of Borno State.",
            "Free schooling, lower taxes, better infrastructure.. I made promises.",
            "Now the real work begins.",
          ],
        ),
      ],
    ),

    "node_1": NodePresentation(
      dayNumber: 1,
      beats: [
        // Beat 1: Adamu congratulates
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Your Excellency, congratulations again on the victory.",
            "The people have spoken, and Borno is ready for change.",
          ],
        ),

        // Beat 2: Paper on desk
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/paper.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "*He slides a folded document onto your desk.*",
          ],
        ),

        // Beat 3: Back to office, Adamu continues
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "But we need to discuss something... sensitive.",
            "During the campaign, we received support from various groups.",
            "Business associations, community leaders, traditional councils.",
            "They believed in our vision.",
          ],
        ),

        // Beat 4: Adamu continues
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "They're expecting... recognition.",
            "Approximately 50 million naira worth of recognition.",
          ],
        ),

        // Beat 5: Player reacts
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "50 million? For what exactly?",
          ],
        ),

        // Beat 6: Adamu explains
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Campaign expenses, mobilization fees, logistics.",
            "You know how these things work.",
            "Now they need to see returns, or...",
          ],
        ),
      ],
    ),

    "node_2": NodePresentation(
      dayNumber: 5,
      beats: [
        // Beat 1: Chief Okonkwo introduces the problem
        DialogueBeat(
          speaker: "Chief Okonkwo",
          background: "assets/images/office2.png",
          portrait: "assets/images/okonkwo.png",
          color: 0xFFC1121F,
          lines: [
            "Governor, we need to discuss your education promise. Free schooling for all children in Borno State.",
            "The numbers don't work. The education ministry needs 200 million naira to implement this properly.",
            "The state treasury has... 80 million allocated.",
          ],
        ),

        // Beat 2: Player responds
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office2.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "What are you suggesting?",
          ],
        ),

        // Beat 3: Chief Okonkwo explains rural fund option
        DialogueBeat(
          speaker: "Chief Okonkwo",
          background: "assets/images/office2.png",
          portrait: "assets/images/okonkwo.png",
          color: 0xFFC1121F,
          lines: [
            "There is 150 million naira sitting unused for rural infrastructure fund. Those projects won't start until next year anyway.",
            "The villagers are patient people, they've waited decades for roads.",
          ],
        ),

        // Beat 4: Player reacts
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office2.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "You want me to take money meant for rural development?",
          ],
        ),

        // Beat 5: Chief Okonkwo presents private school option
        DialogueBeat(
          speaker: "Chief Okonkwo",
          background: "assets/images/office2.png",
          portrait: "assets/images/okonkwo.png",
          color: 0xFFC1121F,
          lines: [
            "There's also... interest from the private school association.",
            "They've offered to 'support' your administration with 30 million naira in exchange for reconsidering the free education policy.",
          ],
        ),
      ],
    ),

    "node_3": NodePresentation(
      dayNumber: 10,
      beats: [
        DialogueBeat(
          speaker: "Dola",
          background: "assets/images/construction.png",
          portrait: "assets/images/dola.png",
          color: 0xFF2D5016,
          lines: [
            "Your Excellency, we need to discuss the Maiduguri-Bama highway project.",
            "It's been delayed for 5 years. 500 km of road that could transform commerce in the region.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/construction.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "What's the status?",
          ],
        ),
        DialogueBeat(
          speaker: "Dola",
          background: "assets/images/construction.png",
          portrait: "assets/images/dola.png",
          color: 0xFF2D5016,
          lines: [
            "We have two bids. The international firm - Chinese consortium. Excellent track record, 800 million naira.",
            "They'll use quality materials, finish in 18 months, full warranty.",
          ],
        ),
        DialogueBeat(
          speaker: "Dola",
          background: "assets/images/construction.png",
          portrait: "assets/images/dola.png",
          color: 0xFF2D5016,
          lines: [
            "Then there's Alhaji Bello's company. Local contractor. His bid is 600 million naira.",
            "He's offered you 20% of the contract value. 120 million naira. To your personal account.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/construction.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "And the quality?",
          ],
        ),
        DialogueBeat(
          speaker: "Dola",
          background: "assets/images/construction.png",
          portrait: "assets/images/dola.png",
          color: 0xFF2D5016,
          lines: [
            "Alhaji Bello... cuts corners. Thinner asphalt, cheaper materials. The road might last five years instead of twenty.",
            "That 120 million could fund other projects... or secure your family's future.",
          ],
        ),
      ],
    ),

    "node_4": NodePresentation(
      dayNumber: 20,
      beats: [
        DialogueBeat(
          speaker: "Mother",
          background: "assets/images/home.png",
          portrait: "assets/images/mother.png",
          color: 0xFFCC5500,
          lines: [
            "My son, the Governor. I'm so proud of you.",
          ],
        ),
        DialogueBeat(
          speaker: "Mother",
          background: "assets/images/home.png",
          portrait: "assets/images/mother.png",
          color: 0xFFCC5500,
          lines: [
            "But I need to talk to you about Ibrahim. Your cousin.",
            "He lost his job at the bank. His wife is pregnant with their third child.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/home.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "I'm sorry to hear that, Mama.",
          ],
        ),
        DialogueBeat(
          speaker: "Mother",
          background: "assets/images/home.png",
          portrait: "assets/images/mother.png",
          color: 0xFFCC5500,
          lines: [
            "He needs work. He's family. You can help him.",
            "A position in the government. Something with a good salary. He has a university degree.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/home.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "What kind of position?",
          ],
        ),
        DialogueBeat(
          speaker: "Mother",
          background: "assets/images/home.png",
          portrait: "assets/images/mother.png",
          color: 0xFFCC5500,
          lines: [
            "The licensing board. Or procurement. Somewhere he can... make a living.",
          ],
        ),
      ],
    ),

    "node_5": NodePresentation(
      dayNumber: 40,
      beats: [
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/press.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Governor, we have a problem. A serious one.",
            "Amina Yusuf. The journalist from Daily Trust. She's been investigating.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/press.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "Investigating what?",
          ],
        ),
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/press.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Everything. The infrastructure contracts. The education budget. Your cousin's appointment.",
            "She has evidence and is giving you 48 hours to comment before she publishes.",
          ],
        ),
      ],
    ),

    "node_6": NodePresentation(
      dayNumber: 50,
      beats: [
        DialogueBeat(
          speaker: "Reporter",
          background: "assets/images/bridge_collapse.png",
          portrait: "assets/images/reporter.png",
          color: 0xFFC1121F,
          lines: [
            "Breaking news from Borno State. The Maiduguri-Bama highway bridge has collapsed.",
            "At least 15 people confirmed dead. Dozens more injured.",
          ],
        ),
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/crisis_room.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Governor, the media is outside. They're demanding answers.",
            "The bridge was part of Alhaji Bello's contract. The one from three months ago.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/crisis_room.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "How did this happen?",
          ],
        ),
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/crisis_room.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Cheap materials. Poor construction. Exactly what we feared.",
            "If you took that kickback, they'll find out. The investigation will reveal everything.",
          ],
        ),
      ],
    ),

    "node_6_check": NodePresentation(
      dayNumber: 50,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/office.png",
          portrait: "assets/images/default.png",
          color: 0xFF003049,
          lines: [
            "Months pass...",
            "The consequences of your decisions begin to unfold.",
          ],
        ),
      ],
    ),

    "node_6_clean": NodePresentation(
      dayNumber: 50,
      beats: [
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "Governor, your term is coming to an end.",
            "The party chairman wants to discuss your re-election campaign.",
          ],
        ),
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "What are they saying?",
          ],
        ),
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/office.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "They're... concerned. Your infrastructure projects succeeded, but you made enemies.",
            "Some party leaders want you to 'play ball' now. Make some compromises to secure their support.",
            "Others respect what you've built.",
          ],
        ),
      ],
    ),

    "ending_martyr": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/martyr.png",
          portrait: "assets/images/default.png",
          color: 0xFF003049,
          lines: [
            "THE MARTYR",
            "",
            "The courtroom falls silent as the judge reads your sentence.",
            "Your family weeps in the gallery. The infrastructure fund you diverted sits frozen in foreign accounts whilst schools remain closed.",
            "But you stood firm when it mattered. You refused to let corruption continue, even knowing it would destroy you.",
            "Your testimony triggers real investigations. International pressure mounts. Reform movements begin.",
            "In prison, you receive letters. From students. From activists. From people who believe change is possible because you proved it.",
            "Your career is over. Your freedom is gone. But your legacy? That belongs to the future.",
          ],
        ),
      ],
    ),

    "ending_survivor": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/idealist.png",
          portrait: "assets/images/default.png",
          color: 0xFF780000,
          lines: [
            "THE BROKEN IDEALIST",
            "",
            "You lost the re-election by a landslide. 73% voted against you.",
            "You tried. God knows you tried. You refused the bribes, rejected the kickbacks, stood firm against the pressure.",
            "And you achieved nothing. The schools stayed closed. The roads stayed broken. The people still suffer.",
            "The new governor? He took office with a smile and promises. Within a month, the kickbacks started flowing again.",
            "Your successor will steal more in his first year than you refused in your entire term.",
            "You return to private life with your integrity intact. Your hands are clean.",
            "But the children still can't read. The roads still kill. And nobody remembers your name.",
            "Good intentions aren't enough. They never were.",
          ],
        ),
      ],
    ),

    "ending_corruptor": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/corruptor.png",
          portrait: "assets/images/default.png",
          color: 0xFFC1121F,
          lines: [
            "THE COMFORTABLE CORRUPTOR",
            "",
            "You sit in your mansion in Abuja, surrounded by luxury your salary could never afford.",
            "Your children attend the finest schools in London. Your accounts overflow with money meant for hospitals, schools, roads.",
            "Outside your gates, the Maiduguri-Bama highway crumbles. Fifteen people died on that bridge. Fifteen families destroyed.",
            "The schools you promised remain closed. Children learn under trees because the education fund sits in your offshore account.",
            "Sometimes, late at night, you see their faces. The people who believed in you. The people you betrayed.",
            "But morning comes. The guilt fades. You pour another drink and count your money.",
            "You won. Didn't you?",
          ],
        ),
      ],
    ),

    "ending_whistleblower": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/whistleblower.png",
          portrait: "assets/images/default.png",
          color: 0xFF003049,
          lines: [
            "THE WHISTLEBLOWER",
            "",
            "The press conference changes everything. You confess it all.",
            "The kickbacks. The diverted funds. The pressure. The compromises. You name names. You provide evidence.",
            "Within hours, you're finished. Your political career is over. Your family receives death threats.",
            "Your mother won't speak to you. Your wife takes the children to her family. You may never be safe in Nigeria again.",
            "But the investigation begins. Real investigation. The EFCC moves. International pressure mounts.",
            "Three governors resign within a month. Two are arrested. The system is shaking.",
            "You lost everything. Your career. Your family. Your safety. Perhaps your future.",
            "But you told the truth. In a system built on lies, that might be the only victory that matters.",
          ],
        ),
      ],
    ),

    "ending_reformer": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "",
          background: "assets/images/reformer.png",
          portrait: "assets/images/default.png",
          color: 0xFF003049,
          lines: [
            "THE REFORMER",
            "",
            "The new school in Maiduguri opens its doors. Real teachers. Proper books. Equipment that works.",
            "The highway is completed. Quality construction. It will last decades, not years.",
            "You walk through the market and children run to you. Not for money. Not for favours. To say thank you.",
            "It wasn't easy. You made powerful enemies. People wanted you to fail, to prove that honest governance is impossible.",
            "You faced threats. Pressure. Isolation. There were nights you nearly broke.",
            "But you didn't. You held the line. You proved them wrong.",
            "The system is still corrupt. One governor cannot fix everything. But you changed something real.",
            "And that's how real reform begins. One honest person. One kept promise. One step at a time.",
          ],
        ),
      ],
    ),
  };

  static NodePresentation forId(String id) {
    return data[id] ??
        NodePresentation(
          dayNumber: 1,
          beats: [
            DialogueBeat(
              speaker: "Advisor",
              background: "assets/images/office.png",
              portrait: "assets/images/portraits/default.png",
              color: 0xFF003049,
              lines: [
                "No custom dialogue defined for this situation yet.",
              ],
            ),
          ],
        );
  }
}