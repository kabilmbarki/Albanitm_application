import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = '';
  String email = '';
  String companyName = '';
  String password = '';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late FirebaseAuth _auth;
  User? _user;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      if (_user != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid) // access the user UID safely
            .get();

        if (documentSnapshot.exists) {
          setState(() {
            fullName = documentSnapshot['fullName'];
            email = documentSnapshot['email'];
            companyName = documentSnapshot['companyName'];
            password = documentSnapshot['password'];

            // Assuming password is not fetched for security reasons
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _updateProfileData(String field, String value) async {
    try {
      if (_user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({field: value});
      }
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  void _editFullName() {
    _fullNameController.text = fullName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Full Name'),
        content: TextField(
          controller: _fullNameController,
          decoration: InputDecoration(labelText: 'Full Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                fullName = _fullNameController.text;
              });
              _updateProfileData('fullName', fullName);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editEmail() {
    _emailController.text = email;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Email'),
        content: TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                email = _emailController.text;
              });
              _updateProfileData('email', email);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editCompanyName() {
    _companyNameController.text = companyName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Company Name'),
        content: TextField(
          controller: _companyNameController,
          decoration: InputDecoration(labelText: 'Company Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                companyName = _companyNameController.text;
              });
              _updateProfileData('companyName', companyName);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_currentPasswordController.text.isNotEmpty &&
                  _newPasswordController.text ==
                      _confirmPasswordController.text) {
                try {
                  if (_user != null) {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: email,
                      password: _currentPasswordController.text,
                    );
                    await _user!.reauthenticateWithCredential(credential);
                    await _user!.updatePassword(_newPasswordController.text);
                    setState(() {
                      password = _newPasswordController.text;
                    });
                    _updateProfileData('password', password);
                    Navigator.pop(context);
                  }
                } catch (e) {
                  print('Error changing password: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Password change failed. Please check your inputs.'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Password change failed. Please check your inputs.'),
                ));
              }
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Full Name'),
              subtitle: Text(fullName),
              trailing: Icon(Icons.edit),
              onTap: _editFullName,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
              trailing: Icon(Icons.edit),
              onTap: _editEmail,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Company Name'),
              subtitle: Text(companyName),
              trailing: Icon(Icons.edit),
              onTap: _editCompanyName,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Password'),
              subtitle: Text('********'),
              trailing: Icon(Icons.edit),
              onTap: _editPassword,
            ),
          ],
        ),
      ),
    );
  }
}
