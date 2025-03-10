import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 추가
import 'intro_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFA22820),
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'DEEP\nLEARNING\nCHATBOT',
                      style: GoogleFonts.rubikMonoOne( // 변경
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Image.asset(
                      'assets/ch_logo.png',
                      width: 300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red[900],
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Enter', style: GoogleFonts.rubikMonoOne(fontSize: 18)), // 변경
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const IntroPage()),
                        );
                      },
                    ),
                  ),
                ),
              ]),
        ));
  }
}