import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> dataList = jsonDecode(_jsonData());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: 300,
        child: Chart(
          rebuild: false,
          data: dataList,
          variables: {
            'Year': Variable(
              accessor: (dynamic datum) => datum['year'] as String,
              scale: OrdinalScale(inflate: true, tickCount: 8),
            ),
            'Value (USD)': Variable(
              accessor: (dynamic datum) => datum['value'] as double,
              scale: LinearScale(
                formatter: (v) {
                  var nf = NumberFormat();
                  nf.maximumFractionDigits = 2;

                  return '\$${nf.format(v)} B';
                },
              ),
            ),
          },
          marks: [
            LineMark(
              color: ColorEncode(value: Colors.deepOrange),
              shape: ShapeEncode(
                value: BasicLineShape(smooth: true),
              ),
              transition: Transition(
                duration: const Duration(seconds: 2),
              ),
              entrance: {
                MarkEntrance.x,
                MarkEntrance.y,
                MarkEntrance.opacity,
              },
            ),
          ],
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
          selections: {
            'tooltipMouse': PointSelection(
              on: {
                GestureType.hover,
              },
              devices: {PointerDeviceKind.mouse},
              dim: Dim.x,
            ),
            'tooltipTouch': PointSelection(
              on: {GestureType.scaleUpdate, GestureType.tapDown, GestureType.longPressMoveUpdate},
              devices: {PointerDeviceKind.touch},
              dim: Dim.x,
            ),
          },
          tooltip: TooltipGuide(
            followPointer: [true, true],
            align: Alignment.topLeft,
          ),
          crosshair: CrosshairGuide(
            followPointer: [false, true],
          ),
          annotations: [
            RegionAnnotation(
              values: ['2020', '2021'],
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _jsonData() {
    return '''
    [
  {
    "year": "2015",
    "value": 95.839
  },
  {
    "year": "2016",
    "value": 95.749
  },
  {
    "year": "2017",
    "value": 100.000
  },
  {
    "year": "2018",
    "value": 105.780
  },
  {
    "year": "2019",
    "value": 109.017
  },
  {
    "year": "2020",
    "value": 103.888
  },
  {
    "year": "2021",
    "value": 112.884
  },
  {
    "year": "2022",
    "value": 118.316
  },
  {
    "year": "2023",
    "value": 116.944
  }
]
    ''';
  }
}
