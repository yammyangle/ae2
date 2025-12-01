import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsBar extends StatelessWidget {
  final double corruptionLevel;       // 0–100
  final double publicTrust;           // 0–100
  final double personalWealth;        // any scale, but we’ll show as number
  final double infrastructureQuality; // 0–100
  final double politicalCapital;      // 0–100

  const StatsBar({
    super.key,
    required this.corruptionLevel,
    required this.publicTrust,
    required this.personalWealth,
    required this.infrastructureQuality,
    required this.politicalCapital,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0D5).withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFC1121F),
            width: 2,
          ),
        ),
      ),

      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ★ Title smaller + darker
              Text(
                "Governor of Borno",
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF003049), // deep blue
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ★ SINGLE ROW FOR ALL STATS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tinyStat("Corr", corruptionLevel, const Color(0xFFC1121F)),
                  _tinyStat("Trust", publicTrust, const Color(0xFF669BBC)),
                  _tinyStat("Infra", infrastructureQuality, const Color(0xFF003049)),
                  _tinyStat("Cap", politicalCapital, const Color(0xFFC1121F)),
                  _tinyWealth(personalWealth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }





  Widget _tinyStat(String label, double value, Color barColor) {
    return SizedBox(
      width: 60, // VERY small, fits one row
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ${value.toInt()}",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003049),
            ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value.clamp(0, 100) / 100,
              minHeight: 3,
              backgroundColor: const Color(0xFF669BBC).withOpacity(0.25),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tinyWealth(double value) {
    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Wealth",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003049),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "${value.toStringAsFixed(0)} M",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003049),
            ),
          ),
        ],
      ),
    );
  }

}
