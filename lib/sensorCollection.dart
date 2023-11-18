import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<StatefulWidget> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  var accelerometerData =
      FirebaseFirestore.instance.collection('AccelerometerData');
  var gyroscopeData = FirebaseFirestore.instance.collection('GyroscopeData');
  var magnetometerData =
      FirebaseFirestore.instance.collection('MagnetometerData');

  double _accelerometerX = 0.0;
  double _accelerometerY = 0.0;
  double _accelerometerZ = 0.0;

  double _gyroscopeX = 0.0;
  double _gyroscopeY = 0.0;
  double _gyroscopeZ = 0.0;

  double _magnetometerX = 0.0;
  double _magnetometerY = 0.0;
  double _magnetometerZ = 0.0;

  void startOtherSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
      });
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeX = event.x;
        _gyroscopeY = event.y;
        _gyroscopeZ = event.z;
      });
    });
    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerX = event.x;
        _magnetometerY = event.y;
        _magnetometerZ = event.z;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    startOtherSensors();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data Collection'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Go back!'),
            ),
            ElevatedButton(
                onPressed: startOtherSensors,
                child: const Text("Start Collection"))
          ],
        ),
      ),
    );
  }

  Future<void> startAcceleroleterCollection() async {
    accelerometerData.add(
        {"X": _accelerometerX, "Y": _accelerometerY, "Z": _accelerometerZ});
  }

  Future<void> startGyroscopeCollection() async {
    gyroscopeData.add({"X": _gyroscopeX, "Y": _gyroscopeY, "Z": _gyroscopeZ});
  }

  Future<void> startMagnetometerCollection() async {
    magnetometerData
        .add({"X": _magnetometerX, "Y": _magnetometerY, "Z": _magnetometerZ});
  }
}
