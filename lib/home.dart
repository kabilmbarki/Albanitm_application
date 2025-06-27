import 'package:albanitm/controller.dart';
import 'package:albanitm/notification_service.dart';

import 'package:albanitm/profile.dart';
import 'package:albanitm/quantity.dart';
import 'package:albanitm/technicians.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<double> humidityData = [0, 0, 0, 0, 0, 0, 0];
  late List<double> temperatureData = [0, 0, 0, 0, 0, 0, 0];

  String hum = '0';
  String temp = '0';

  int _currentIndex = 0;

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  GlobalKey<FormState> formstate = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeTemperatureListener();
    _initializeHumidityListener();
    _fetchTemperatureData();
    _fetchHumidityData();
  }

  void _fetchTemperatureData() async {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('tempweek');

    DataSnapshot snapshot = await tempRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        temperatureData = [
          (data['day1'] ?? 0).toDouble(),
          (data['day2'] ?? 0).toDouble(),
          (data['day3'] ?? 0).toDouble(),
          (data['day4'] ?? 0).toDouble(),
          (data['day5'] ?? 0).toDouble(),
          (data['day6'] ?? 0).toDouble(),
          (data['day7'] ?? 0).toDouble(),
        ];
      });
    } else {
      print("No data available");
    }
  }

  void _fetchHumidityData() async {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('humweek');

    DataSnapshot snapshot = await tempRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        humidityData = [
          (data['day1'] ?? 0).toDouble(),
          (data['day2'] ?? 0).toDouble(),
          (data['day3'] ?? 0).toDouble(),
          (data['day4'] ?? 0).toDouble(),
          (data['day5'] ?? 0).toDouble(),
          (data['day6'] ?? 0).toDouble(),
          (data['day7'] ?? 0).toDouble(),
        ];
      });
    } else {
      print("No data available");
    }
  }

  void _initializeTemperatureListener() {
    DatabaseReference _getdata =
        FirebaseDatabase.instance.ref().child('temperature');
    _getdata.onValue.listen((event) {
      setState(() {
        temp = event.snapshot.value.toString();
      });

      double currentTemperature = double.parse(temp);
      if (currentTemperature > 45) {
        NotificationService.showSimpleNotification(
          title: "High Temperature Alert",
          body: "The temperature is too high: $currentTemperature°C",
          payload: "$currentTemperature°C",
        );
      }
    });
  }

  void _initializeHumidityListener() {
    DatabaseReference _getdata =
        FirebaseDatabase.instance.ref().child('humidity');
    _getdata.onValue.listen(
      (event) {
        setState(() {
          hum = event.snapshot.value.toString();
        });
        double currentHumidity = double.parse(hum);
        if (currentHumidity > 60) {
          NotificationService.showSimpleNotification(
            title: "High Humidity Alert",
            body: "The Humidity is too high: $currentHumidity %",
            payload: "$currentHumidity %",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InfoBox(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '$hum %',
                  color: Colors.blue,
                ),
                InfoBox(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: ' $temp °C',
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: LineChartWidget(
                      data: humidityData,
                      color: Colors.blue,
                      title: 'Humidity',
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: LineChartWidget(
                      data: temperatureData,
                      color: Colors.red,
                      title: 'Temperature',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      QuantityPage(),
      ControllerPage(),
      //NotificationPage(),
      //ChatPage(),
      TechniciansPage(),
      ProfilePage(),
    ];
    return Scaffold(
      //backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('AlbaniTM'),
        backgroundColor: Colors.white54,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 30,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Quantity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Control',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: 'Notifications',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Technicians',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const InfoBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 48.0,
            color: color,
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final Color color;
  final String title;

  const LineChartWidget({
    required this.data,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value) {
                        case 0:
                          return Text('Mon');
                        case 1:
                          return Text('Tue');
                        case 2:
                          return Text('Wed');
                        case 3:
                          return Text('Thu');
                        case 4:
                          return Text('Fri');
                        case 5:
                          return Text('Sat');
                        case 6:
                          return Text('Sun');
                        default:
                          return Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),
                  isCurved: true,
                  color: color,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
