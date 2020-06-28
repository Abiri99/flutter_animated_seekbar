import 'package:animatedseekbar/animated_seekbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Seekbar"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: AnimatedSeekbar(
            size: Size(
              300,
              300,
            ),
          ),
        ),
      ),
    );
  }
}
