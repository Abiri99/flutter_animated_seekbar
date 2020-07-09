import 'package:bouncyseekbar/range_picker/elastic_range_picker.dart';
import 'package:bouncyseekbar/seekbar/elastic_seekbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _progress;

  double val;
  double val2;

  @override
  void initState() {
    _progress = "";
    val = 0;
    val2 = 0.5;
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
              ElasticSeekBar(
                thickLineStrokeWidth: 4,
                thinLineStrokeWidth: 1,
                minValue: 0,
                stretchRange: 60,
                bounceDuration: Duration(seconds: 1),
                maxValue: 100,
                valueListener: (String value) {
//                  setState(() {
//                    _progress = value;
//                  });
                },
                size: Size(
                  300,
                  100,
                ),
              ),
//              Slider(
//                value: val,
//                onChanged: (value) {
//                  setState(() {
//                    val = value;
//                  });
//                },
//              ),
              SizedBox(
                height: 100,
              ),
//              ElasticSeekBar(
//                thickLineStrokeWidth: 4,
//                thinLineStrokeWidth: 1,
//                minValue: 0,
//                stretchRange: 60,
//                bounceDuration: Duration(seconds: 1),
//                maxValue: 100,
//                valueListener: (String value) {
////                  setState(() {
////                    _progress = value;
////                  });
//                },
//                size: Size(
//                  300,
//                  100,
//                ),
//              ),

              ElasticRangePicker(
                valueListener: (firstVal, secVal) {},
                size: Size(
                  300,
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
