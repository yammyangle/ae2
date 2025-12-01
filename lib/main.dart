import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(
      duration: 3,
      goToPage: HomePage(),
    ),
  ));
}

class SplashPage extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage({super.key, required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => goToPage),
      );
    });

    return const Scaffold(
      body: ColoredBox(
        color: Color.fromARGB(255, 0, 48, 73),
        child: Center(
          child: Icon(
            Icons.flag,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            /// Background image with opacity
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/Victory.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  const Text(
                    'The State of Secret',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Congratulations, Your Excellency! You won the election! Now the real game begins. The contractors want their cuts, the party leaders want their loyalty rewards, and your personal bank account is looking... lonely. Sure, you could build that hospital or fix the roads. But a private jet is so much faster. How will you rule? For the people, or for yourself? Choose wisely.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Correct TextButton
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 48, 73),
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // rectangle shape
                      ),
                    ),
                    child: const Text(
                      'Begin Game',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   const SizedBox(height: 30),
                  Material(
                    color: Colors.transparent,
                    child:InkWell(
                      
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 48, 73),
                            width: 4,
                          )
                        ),
                      child: Text('Saved Games',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 48, 73),
                          fontWeight: FontWeight.bold
                        )
                        ),
                    ),
                    ),
                  )
                ],
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
