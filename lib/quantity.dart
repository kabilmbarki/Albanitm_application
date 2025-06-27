import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class QuantityPage extends StatefulWidget {
  @override
  State<QuantityPage> createState() => _QuantityPageState();
}

class _QuantityPageState extends State<QuantityPage> {
  List<double> choice1Data = [0, 0, 0, 0, 0, 0, 0];
  List<double> choice2Data = [0, 0, 0, 0, 0, 0, 0];
  List<double> choice3Data = [0, 0, 0, 0, 0, 0, 0];

  String prem = '0';
  String sec = '0';
  String thr = '0';

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  GlobalKey<FormState> formstate = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializechoice1Listener();
    _initializechoice2Listener();
    _initializechoice3Listener();
    _fetchchoice1Data();
    _fetchchoice2Data();
    _fetchchoice3Data();
  }

  void _fetchchoice1Data() async {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('firstchoiceweek');

    DataSnapshot snapshot = await tempRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        choice1Data = [
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

  void _fetchchoice2Data() async {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('secondchoiceweek');

    DataSnapshot snapshot = await tempRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        choice2Data = [
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

  void _fetchchoice3Data() async {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('therdchoiceweek');

    DataSnapshot snapshot = await tempRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        choice3Data = [
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

  void _initializechoice1Listener() {
    DatabaseReference _getdata =
        FirebaseDatabase.instance.ref().child('firstchoice');
    _getdata.onValue.listen(
      (event) {
        setState(() {
          prem = event.snapshot.value.toString();
        });
      },
    );
  }

  void _initializechoice2Listener() {
    DatabaseReference _getdata =
        FirebaseDatabase.instance.ref().child('secondchoice');
    _getdata.onValue.listen(
      (event) {
        setState(() {
          sec = event.snapshot.value.toString();
        });
      },
    );
  }

  void _initializechoice3Listener() {
    DatabaseReference _getdata =
        FirebaseDatabase.instance.ref().child('theredchoice');
    _getdata.onValue.listen(
      (event) {
        setState(() {
          thr = event.snapshot.value.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InfoBox(
                      icon: Icons.looks_one,
                      label: '1st Choice',
                      value: ' $prem %',
                      color: Colors.green,
                    ),
                    SizedBox(width: 16), // Add some spacing between InfoBoxes
                    InfoBox(
                      icon: Icons.looks_two,
                      label: '2nd Choice',
                      value: ' $sec %',
                      color: Colors.orange,
                    ),
                    SizedBox(width: 16), // Add some spacing between InfoBoxes
                    InfoBox(
                      icon: Icons.looks_3,
                      label: '3rd Choice',
                      value: ' $thr %',
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              LineChartWidget(
                data: choice1Data,
                color: Colors.green,
                title: '1st Choice',
              ),
              const SizedBox(height: 20),
              LineChartWidget(
                data: choice2Data,
                color: Colors.orange,
                title: '2nd Choice',
              ),
              const SizedBox(height: 20),
              LineChartWidget(
                data: choice3Data,
                color: Colors.purple,
                title: '3rd Choice',
              ),
            ],
          ),
        ),
      ),
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
        Container(
          height: 200, // Set a fixed height for each chart
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
