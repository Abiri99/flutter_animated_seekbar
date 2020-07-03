import 'package:bouncyseekbar/range_picker/bouncy_range_picker.dart';
import 'package:bouncyseekbar/seekbar/bouncy_seekbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _progress;

  @override
  void initState() {
    _progress = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Seekbar"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BouncySeekbar(
                thickLineStrokeWidth: 4,
                thinLineStrokeWidth: 1,
                minValue: 0,
                stretchRange: 60,
                maxValue: 100,
                valueListener: (String value) {
                  print("val: $value");
                  setState(() {
                    _progress = value;
                  });
                },
                size: Size(
                  300,
                  100,
                ),
              ),

              BouncyRangePikcer(
                rangeListener: (firstVal, secVal) {},
                size: Size(
                  200,
                  100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
