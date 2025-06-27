import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final bool isConveyorBeltFull =
      true; // Example status, you can change this based on your logic
  final int quantityLevel =
      75; // Example quantity level, you can change this based on your logic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Conveyor Belt Status',
                message: isConveyorBeltFull
                    ? 'The conveyor belt is full.'
                    : 'The conveyor belt is not full.',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Quantity Status',
                message: 'Current quantity level is $quantityLevel%.',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Fan Status',
                message: 'Fan is On ',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Conveyor Belt Status',
                message: isConveyorBeltFull
                    ? 'The conveyor belt is full.'
                    : 'The conveyor belt is not full.',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Quantity Status',
                message: 'Current quantity level is $quantityLevel%.',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Fan Status',
                message: 'Fan Close ',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Conveyor Belt Status',
                message: isConveyorBeltFull
                    ? 'The conveyor belt is full.'
                    : 'The conveyor belt is not full.',
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 400,
              child: NotificationCard(
                title: 'Quantity Status',
                message: 'Current quantity level is $quantityLevel%.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;

  const NotificationCard({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
