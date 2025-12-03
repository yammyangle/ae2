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
          speaker: "Narrator",
          background: "assets/images/victory.png",
          portrait: "assets/images/default.png",
          color: 0xFF003049,
          lines: [
            "You have just won the election for Governor of Borno State.",
            "Free schooling, lower taxes, better infrastructure - these were your promises.",
            "Now the real work begins.",
          ],
        ),
      ],
    ),

    "node_1": NodePresentation(
      dayNumber: 1,
      beats: [
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
        DialogueBeat(
          speaker: "Adamu",
          background: "assets/images/paper.png",
          portrait: "assets/images/adamu.png",
          color: 0xFF003049,
          lines: [
            "*He slides a folded document onto your desk.*",
          ],
        ),
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
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "50 million? For what exactly?",
          ],
        ),
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
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office2.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "What are you suggesting?",
          ],
        ),
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
        DialogueBeat(
          speaker: "You",
          background: "assets/images/office2.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "You want me to take money meant for rural development?",
          ],
        ),
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
          speaker: "THE MARTYR",
          background: "assets/images/martyr.png",
          portrait: "assets/images/player.png",
          color: 0xFF003049,
          lines: [
            "The courtroom is silent as the judge reads your sentence.",
            "Twenty years. Your family weeps in the gallery.",
            "You exposed the system, and the system crushed you. They found technicalities, old laws, anything to silence you.",
            "In prison, you receive letters. Activists call you a hero. Students study your testimony. Your sacrifice lit a fire.",
            "But your children will grow up without you. Your mother died while you awaited trial.",
            "You told the truth. And the truth destroyed your life.",
          ],
        ),
      ],
    ),

    "ending_survivor": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "THE BROKEN IDEALIST",
          background: "assets/images/idealist.png",
          portrait: "assets/images/player.png",
          color: 0xFF780000,
          lines: [
            "You lost the re-election by a landslide. Seventy-three percent voted against you.",
            "You refused every bribe. Rejected every shortcut. Stayed true to your principles.",
            "And you accomplished nothing.",
            "The new governor is already making deals. The system continues as it always has.",
            "Your integrity is intact. Your conscience is clear.",
            "But the schools are still broken. The roads still kill. The corruption still spreads.",
            "You return to private life with your dignity. And nothing else.",
            "The children still can't read. And you can sleep at night.",
            "You wonder which matters more.",
          ],
        ),
      ],
    ),

    "ending_corruptor": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "THE COMFORTABLE CORRUPTOR",
          background: "assets/images/corruptor.png",
          portrait: "assets/images/player.png",
          color: 0xFFC1121F,
          lines: [
            "Your mansion in Abuja has twelve bedrooms. Your children attend private schools in London.",
            "The offshore accounts are untraceable. The paper trail is immaculate.",
            "You were never caught. You played the game better than most.",
            "Sometimes, late at night, you think about the bridge that collapsed. Fifteen people died. Your contractor had cut corners - with your approval.",
            "The schools you closed still haven't reopened. The education fund you embezzled could have changed thousands of lives.",
            "But morning always comes. And with it, another day of luxury.",
            "You won. And everyone else lost.",
          ],
        ),
      ],
    ),

    "ending_whistleblower": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "THE WHISTLEBLOWER",
          background: "assets/images/whistleblower.png",
          portrait: "assets/images/player.png",
          color: 0xFF003049,
          lines: [
            "The press conference is packed. Your hands shake as you present the evidence.",
            "Names. Dates. Bank accounts. Everything.",
            "You confess your own crimes. And you expose everyone else's.",
            "Your career is over. Your family receives threats. Your mother won't speak to you.",
            "But within a month, the EFCC launches investigations. Three governors resign. Two are arrested.",
            "The system fights back. But for the first time in decades, it's actually wounded.",
            "You lost everything. But you told the truth.",
            "History will remember your name - though you'll never know if that was worth it.",
          ],
        ),
      ],
    ),

    "ending_reformer": NodePresentation(
      dayNumber: 100,
      beats: [
        DialogueBeat(
          speaker: "THE REFORMER",
          background: "assets/images/reformer.png",
          portrait: "assets/images/player.png",
          color: 0xFF003049,
          lines: [
            "The new school in Maiduguri opens on schedule. The children smile as they enter clean classrooms.",
            "The highway you commissioned is the first in decades completed with actual quality materials.",
            "You made powerful enemies. Survived three 'accidents.' Watched your family threatened.",
            "There were moments you nearly broke. Moments the pressure almost crushed you.",
            "But you held the line.",
            "The system is still corrupt. The other governors still steal. The rot runs deep.",
            "But you proved something: change is possible. Difficult, costly, dangerous - but possible.",
            "When you leave office, a little girl thanks you for her school. She means it.",
            "This is what winning looks like. Small. Hard. Real.",
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
              portrait: "assets/images/default.png",
              color: 0xFF003049,
              lines: [
                "No custom dialogue defined for this situation yet.",
              ],
            ),
          ],
        );
  }
}