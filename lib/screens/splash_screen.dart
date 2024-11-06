import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/screens/explore_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),
          () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ExploreScreen()));
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/newzlogo.json'),
          ),
          const SizedBox(height: 200),
          const SpinKitWaveSpinner(
              size: 80,
              color: Colors.red,
            waveColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
