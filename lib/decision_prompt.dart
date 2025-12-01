import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'decision.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DecisionPrompt extends StatelessWidget {
  final Decision decision;
  final Function(DecisionOption) onOptionSelected;

  const DecisionPrompt({
    super.key,
    required this.decision,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      color: const Color(0xFF780000), // Dark red outer frame
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDF0D5), // Cream base
          border: Border.all(
            color: const Color(0xFF669BBC), // Light blue border
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Stack(
          clipBehavior: Clip.none, // allow overlap outside cream box
          children: [
            // ================== OPTIONS BELOW ==================
            Padding(
              // leave room at the top for the overlapping question box
              padding: const EdgeInsets.only(top: 70),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 2),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: decision.options.length <= 2 ? 1 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: decision.options.length == 2 ? 3 : 1.5,
                ),
                itemCount: decision.options.length,
                itemBuilder: (context, index) {
                  final option = decision.options[index];
                  return _buildOptionButton(option);
                },
              ),
            ),

            // ================== OVERLAPPING QUESTION BOX ==================
            Positioned(
              top: -40, // move up so it hangs out of the cream box
              left: -10,
              right: -10,
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF003049), // Deep blue
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFC1121F), // Bright red
                    width: 2,
                  ),
                ),
                child: AutoSizeText(
                  decision.question,
                  style: GoogleFonts.pixelifySans(
                    textStyle: const TextStyle(
                      fontSize: 22,         // max size
                      color: Color(0xFFFDF0D5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  maxLines: 3,             // fits full question in 3 lines
                  minFontSize: 12,         // will shrink if needed
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(DecisionOption option) {
    return ElevatedButton(
      onPressed: () => onOptionSelected(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF669BBC), // Light blue
        foregroundColor: const Color(0xFF003049), // Deep blue text
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFF003049), // Deep blue border
            width: 2,
          ),
        ),
        elevation: 4,
        shadowColor: const Color(0xFF780000).withOpacity(0.5),
      ),
      child: Text(
        option.text,
        style: GoogleFonts.pixelifySans(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
