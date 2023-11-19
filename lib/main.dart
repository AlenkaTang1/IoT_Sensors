import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';
//import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'sensorCollection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(title: 'Mobile Sensors', initialRoute: '/', routes: {
    '/': (context) => MyApp(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/start_collection': (context) => const CollectionPage(),
  }));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //bool _isDisplayingdata = false;
  //int _proximityDistance = 0;
  Duration oneSec = const Duration(seconds: 1);
  var now = DateTime.now();

  var accelerometerData =
      FirebaseFirestore.instance.collection('AccelerometerData');
  var gyroscopeData = FirebaseFirestore.instance.collection('GyroscopeData');
  var magnetometerData =
      FirebaseFirestore.instance.collection('MagnetometerData');
  String _luxString = 'Unknown';
  Light? _light;
  late StreamSubscription<dynamic> _streamSubscriptionProximity;
  StreamSubscription? _subscriptionLight;
  double _accelerometerX = 0.0;
  double _accelerometerY = 0.0;
  double _accelerometerZ = 0.0;

  double _gyroscopeX = 0.0;
  double _gyroscopeY = 0.0;
  double _gyroscopeZ = 0.0;

  double _magnetometerX = 0.0;
  double _magnetometerY = 0.0;
  double _magnetometerZ = 0.0;

  void onData(int luxValue) async {
    setState(() {
      _luxString = "$luxValue";
    });
  }

  void stopListeningLight() {
    _subscriptionLight?.cancel();
  }

  void startListeningLight() {
    _light = Light();
    try {
      _subscriptionLight = _light?.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      _luxString = exception as String;
    }
  }

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

  Future<void> ff() async {
    Timer.periodic(oneSec, (Timer timer) {
      startSensorDataCollection();
    });
  }

  Future<void> startSensorDataCollection() async {
    accelerometerData.add({
      "time": '$now',
      "X": '$_accelerometerX',
      "Y": '$_accelerometerY',
      "Z": '$_accelerometerZ'
    });
    gyroscopeData.add({
      "time": '$now',
      "X": '$_gyroscopeX',
      "Y": '$_gyroscopeY',
      "Z": '$_gyroscopeZ'
    });
    magnetometerData.add({
      "time": '$now',
      "X": '$_magnetometerX',
      "Y": '$_magnetometerY',
      "Z": '$_magnetometerZ'
    });
  }

  @override
  void initState() {
    super.initState();
    //listenSensorProximity();
    startListeningLight();
    startOtherSensors();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionProximity.cancel();
  }

  //Future<void> listenSensorProximity() async {
  // _streamSubscriptionProximity = ProximitySensor.events.listen((int event) {
  // setState(() {
  // _proximityDistance = event;
  // });
  // });
  //}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Sensors'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text('Accelerometer Data:'),
                Text('X: $_accelerometerX'),
                Text('Y: $_accelerometerY'),
                Text('Z: $_accelerometerZ'),
                const SizedBox(height: 20),
                const Text('Gyroscope Data:'),
                Text('X: $_gyroscopeX'),
                Text('Y: $_gyroscopeY'),
                Text('Z: $_gyroscopeZ'),
                const SizedBox(height: 20),
                const Text('Magnetometer Data:'),
                Text('X: $_magnetometerX'),
                Text('Y: $_magnetometerY'),
                Text('Z: $_magnetometerZ'),
                const SizedBox(height: 20),
                Text('Lux value: $_luxString\n'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ff();
                  },
                  child: const Text('Collect'),
                ),

                //Text('proximity distance: $_proximityDistance\n'),
              ],
            )
          ],
        )),
      ),
    );
  }
}
