import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> _numbers = [];
  int _numberOfBars = 500;
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;
  _random() {
    _numbers = [];

    for (var i = 0; i < _numberOfBars; ++i) {
      _numbers.add(Random().nextInt(_numberOfBars));
    }

    _streamController.add(_numbers);
  }

  _sort() async {
    for (var i = 0; i < _numbers.length; i++) {
      for (var j = 0; j < _numbers.length - i - 1; j++) {
        if (_numbers.isNotEmpty && _numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }

        await Future.delayed(Duration(microseconds: 10));
        _streamController.add(_numbers);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _random();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sorting"),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<Object>(
            stream: _stream,
            builder: (context, snapshot) {
              int count = 0;
              return Row(
                children: _numbers.map((int number) {
                  count++;

                  return CustomPaint(
                    painter: BarPaint(
                      width: MediaQuery.of(context).size.width / _numberOfBars,
                      index: count,
                      value: number,
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(onPressed: _random, child: Text("Random")),
          FlatButton(onPressed: _sort, child: Text("Sort")),
        ],
      ),
    );
  }
}

class BarPaint extends CustomPainter {
  final double width;
  final int value;
  final int index;
  BarPaint({@required this.width, @required this.value, @required this.index});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = new Paint();
    paint.color = Colors.teal;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = width;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
