import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'character.dart';
import 'event.dart';

class EventPage extends StatelessWidget {
  final Event event;

  const EventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    const double portraitSize = 150;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // TOP: BACKGROUND IMAGE
          SizedBox(
            height: screenHeight * 0.55,
            width: double.infinity,
            child: Image.asset(
              event.background,
              fit: BoxFit.cover,
            ),
          ),

          // BOTTOM: DIALOG BOX
          Container(
            height: screenHeight * 0.45,
            width: double.infinity,
            color: Colors.black, // outer frame
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFFD7C9A0), // base beige
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ================= MAIN CONTENT =================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------- NAME BAR (FULL WIDTH) -------
                      Container(
                        width: double.infinity, // <<< this now spans the box
                        height: 45,
                        color: const Color(0xFFC8B88A),
                        padding: EdgeInsets.only(
                          left: portraitSize + 3, // room for portrait
                          bottom: 2,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          event.character.name,
                          style: GoogleFonts.ebGaramond(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ------- BODY TEXT (WITH PADDING) -------
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              event.dialogue.join(' '),
                              style: GoogleFonts.ebGaramond(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  height: 1.2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ================= PORTRAIT =================
                  Positioned(
                    left: 0, // flush with left edge of beige box
                    top: -portraitSize * 0.7, // hanging into the background
                    child: Container(
                      width: portraitSize,
                      height: portraitSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4A2C14),
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: AssetImage(event.character.portrait),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
