import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _arrowController;
  late AnimationController _moneyController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _arrowAnimation;

  final List<MoneyBill> _moneyBills = [];
  double _screenHeight = 800;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    super.initState();

    // Bounce animation
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );
    _bounceController.forward();

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Arrow animation
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    // Money rain animation
    _moneyController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(_updateMoneyBills);

    _generateMoneyBills();
    _moneyController.repeat();
  }

  void _updateMoneyBills() {
    setState(() {
      for (var bill in _moneyBills) {
        bill.y += bill.speed;
        bill.rotation += bill.rotationSpeed;

        if (bill.y > _screenHeight) {
          bill.y = -50;
          bill.x += bill.x > 200 ? -100 : 100;
        }
      }
    });
  }

  void _generateMoneyBills() {
    final random = Random();

    for (int i = 0; i < 15; i++) {
      _moneyBills.add(
        MoneyBill(
          x: random.nextDouble() * 400,
          y: -random.nextInt(200).toDouble(),
          speed: 2 + random.nextDouble() * 3,
          rotation: random.nextDouble() * 6.28,
          rotationSpeed: 0.02 + random.nextDouble() * 0.08,
          symbol: ['₦', '💰', '💵'][i % 3],
        ),
      );
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _arrowController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0D5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003049),
        title: Text(
          'How to Play',
          style: GoogleFonts.pixelifySans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildMainScrollContent(),

          /// Money rain overlay
          IgnorePointer(
            child: Stack(
              children: _moneyBills.map((bill) {
                return Positioned(
                  left: bill.x,
                  top: bill.y,
                  child: Transform.rotate(
                    angle: bill.rotation,
                    child: Opacity(
                      opacity: 0.3,
                      child: Text(
                        bill.symbol,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Color(0xFF003049),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  // MAIN SCROLL CONTENT
 
  Widget _buildMainScrollContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScaleTransition(
            scale: _bounceAnimation,
            child: _buildSectionTitle('Game Overview'),
          ),

          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBodyText(
                  'You are the newly elected Governor of Borno State.'
                  'You ran on a platform of liberal reform: free schooling '
                  'lower taxes, and better infrastructure.',
                ),
                const SizedBox(height: 12),
                _buildBodyText(
                  'Every decision you make will affect your governance.'
                  'Balance your integrity with political survival as you '
                  'navigate corruption, family pressure, and public expectations.',

                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('How to Play'),

          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionStep(
                  '1',
                  'Read each scenario carefully',
                  'You will face difficult decisions throughout your term.',
                ),
                const SizedBox(height: 12),
                _buildInstructionStep(
                  '2',
                  'Choose your action',
                  'Each choice has consequences that affect your stats.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Animated arrow pointing upward
          Center(
            child: AnimatedBuilder(
              animation: _arrowAnimation,
              builder: (_, child) {
                return Transform.translate(
                  offset: Offset(0, _arrowAnimation.value),
                  child: child,
                );
              },
              child: Column(
                children: [
                  Text(
                    '👆 Look at the top of your screen! 👆',
                    style: GoogleFonts.pixelifySans(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC1121F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.arrow_upward,
                    color: Color(0xFFC1121F),
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Understanding Your Stats'),

          _buildAnimatedStatCard(
            'Corr (Corruption)',
            '0–100',
            'Measures how corrupt your administration is.',
            const Color(0xFFC1121F),
            Icons.warning_amber,
          ),

          const SizedBox(height: 12),

          _buildAnimatedStatCard(
            'Trust (Public Trust)',
            '0–100',
            'How much the people believe in you.',
            const Color(0xFF669BBC),
            Icons.favorite,
          ),

          //const SizedBox(height: 24),
          const SizedBox(height: 12),

            // Animated Infrastructure Quality
          _buildAnimatedStatCard(
              'Infra (Infrastructure Quality)',
              '0 - 100',
              'The condition of roads, schools, and public facilities. '
              'Poor infrastructure can lead to disasters.',
              const Color(0xFF003049),
              Icons.business,
              
        ),

            const SizedBox(height: 12),

            // Animated Political Capital
            _buildAnimatedStatCard(
              'Cap (Political Capital)',
              '0 - 100',
              'Your influence and ability to get things done. '
              'Low capital means you lose control of your administration.',
              const Color(0xFFC1121F),
              Icons.account_balance,
            
            ),

            const SizedBox(height: 12),

            // Animated Wealth
            _buildAnimatedStatCard(
              'Wealth (Personal Wealth)',
              'Millions (₦)',
              'Your personal finances. You may go into debt or accumulate wealth '
              'depending on your choices. Start at -50M due to campaign debt.',
              const Color(0xFF003049),
              Icons.attach_money,
              //800,
            ),

        ],
      ),
    );
  }


  // CUSTOM UI BUILDERS
 

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.pixelifySans(
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003049),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF003049),
          width: 2,
        ),
      ),
      child: child,
    );
  }

  Widget _buildAnimatedStatCard(
    String title,
    String range,
    String desc,
    Color color,
    IconData icon,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (_, value, child) => Opacity(
        opacity: value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: child,
        ),
      ),
      child: _buildCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003049),
                    ),
                  ),
                  Text(
                    range,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF003049),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF003049),
        height: 1.5,
      ),
    );
  }

  Widget _buildInstructionStep(
      String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF003049),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003049),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF003049),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Money bill class
class MoneyBill {
  double x;
  double y;
  double speed;
  double rotation;
  double rotationSpeed;
  String symbol;

  MoneyBill({
    required this.x,
    required this.y,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
    required this.symbol,
  });
}
