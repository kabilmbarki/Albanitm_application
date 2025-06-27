import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'models/technician.dart';

class TechniciansPage extends StatefulWidget {
  @override
  _TechniciansPageState createState() => _TechniciansPageState();
}

class _TechniciansPageState extends State<TechniciansPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Technician> technicians = [];

  @override
  void initState() {
    super.initState();
    _fetchTechnicians();
  }

  Future<void> _fetchTechnicians() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('technicians').get();
    final List<Technician> loadedTechnicians = snapshot.docs.map((doc) {
      print("/////////////////////////////////////////////////");
      print("${doc.id}");

      print("/////////////////////////////////////////////////");
      return Technician(
        id: doc.id,
        name: doc['fullName'],
        location: doc['location'],
        userEmail: doc['email'],
        imagePath: doc['profileImageUrl'],
      );
    }).toList();

    setState(() {
      technicians = loadedTechnicians;
    });
  }

  void _sendMessage(BuildContext context, Technician technician) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(technician: technician),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: technicians.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: technicians.length,
                itemBuilder: (context, index) {
                  final technician = technicians[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(technician.imagePath),
                        radius: 30.0,
                      ),
                      title: Text(
                        technician.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        technician.location,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.message, color: Colors.blue),
                        onPressed: () => _sendMessage(context, technician),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
