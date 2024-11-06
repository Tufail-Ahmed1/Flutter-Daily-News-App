import 'package:flutter/material.dart';
import 'package:news_app/screens/home_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height*0.60,
            child: Image.asset('assets/splash.png',
            fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: height*0.5,
            margin: const EdgeInsetsDirectional.only(top: 450),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Get The Latest News \n      And Updates',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const Text('Stay updated on everything from politics to entertainment—all the latest news, right at your fingertips',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton(
                    
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                      onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Explore ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.arrow_right_alt,color: Colors.white,),
                        ],
                      ),
                  ),

                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
