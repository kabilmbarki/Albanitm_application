import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:albanitm/notification_service.dart'; // Ensure this is imported for notification

class ControllerPage extends StatefulWidget {
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  bool isWindowOpen = false;
  bool isFanOn = false;
  bool isRobotActive = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _initializeWindowListener();
    _initializeFanListener();
    _initializeRobotListener();
  }

  void _initializeWindowListener() {
    DatabaseReference _windowRef = _databaseReference.child('window');
    _windowRef.onValue.listen((event) {
      bool windowState = (event.snapshot.value as bool?) ?? false;
      setState(() {
        isWindowOpen = windowState;
      });

      if (!windowState) {
        NotificationService.showSimpleNotification(
          title: "Window Closed",
          body: "The window has been closed.",
          payload: 'it\'s closed ',
        );
      }
    });
  }

  void _initializeFanListener() {
    DatabaseReference _fanRef = _databaseReference.child('fanState');
    _fanRef.onValue.listen((event) {
      bool fanState = (event.snapshot.value as bool?) ?? false;
      setState(() {
        isFanOn = fanState;
      });

      if (!fanState) {
        NotificationService.showSimpleNotification(
          title: "Fan Turned Off",
          body: "The fan has been turned off.",
          payload: 'It\'s Closed ',
        );
      }
    });
  }

  void _initializeRobotListener() {
    DatabaseReference _robotRef = _databaseReference.child('robot');
    _robotRef.onValue.listen((event) {
      bool robotState = (event.snapshot.value as bool?) ?? false;
      setState(() {
        isRobotActive = robotState;
      });

      if (!robotState) {
        NotificationService.showSimpleNotification(
          title: "Robot Inactive",
          body: "The robot has been deactivated.",
          payload: ' it\s Closed ',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: ListView(
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isWindowOpen = !isWindowOpen;
                          _databaseReference.child('window').set(isWindowOpen);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isWindowOpen
                                ? Icons.conveyor_belt
                                : Icons.conveyor_belt,
                            size: 150,
                            color: isWindowOpen
                                ? Colors.blue
                                : Color.fromARGB(255, 48, 78, 101),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isWindowOpen ? 'System Open' : 'System Closed',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFanOn = !isFanOn;
                          _databaseReference.child('fan').set(isFanOn);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFanOn
                                ? Icons.mode_fan_off_outlined
                                : Icons.mode_fan_off_rounded,
                            size: 150,
                            color: isFanOn
                                ? Colors.blue
                                : Color.fromARGB(255, 48, 78, 101),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isFanOn ? 'Fan On' : 'Fan Off',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRobotActive = !isRobotActive;
                          _databaseReference.child('robot').set(isRobotActive);
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.robot,
                            size: 150,
                            color: isRobotActive
                                ? Colors.blue
                                : Color.fromARGB(255, 48, 78, 101),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isRobotActive ? 'Robot On' : 'Robot Off',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
