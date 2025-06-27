import 'package:albanitm/technician/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final TextEditingController _fullNameController = TextEditingController();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedGender = 'male';
  File? _profileImage;
  late FirebaseAuth _auth;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _auth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      String fileName = 'profile_images/${_auth.currentUser!.uid}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> _saveUserData(String userId) async {
    String? profileImageUrl = '';
    if (_profileImage != null) {
      profileImageUrl = await _uploadProfileImage(_profileImage!);
    }

    try {
      await FirebaseFirestore.instance
          .collection('technicians')
          .doc(userId)
          .set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'location': _locationController.text.trim(),
        'gender': _selectedGender,
        'password': _passwordController.text.trim(),
        'profileImageUrl': profileImageUrl ?? '',
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _createAccount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        // Passwords don't match
        setState(() {
          _isLoading = false;
          _errorMessage = 'Passwords do not match';
        });
        return;
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Account created successfully
        await _saveUserData(user.uid); // Save user data to Firestore
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ChatPage(
            userEmail: user.email ?? 'default_email@example.com',
            technicianId: user.uid,
          ),
        ));
        print("--------------------------------------------------");
        print('Account created: ${user.uid}');
        print("--------------------------------------------------");
      } else {
        // Handle other cases, such as account creation failed
        print('Unable to create account');
      }
    } catch (e) {
      print('Error creating account: $e');
      // Handle the error
      setState(() {
        _errorMessage = 'Error creating account';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/backgroound.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black
                .withOpacity(0.5), // Optional: Add a semi-transparent overlay
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign Up as Technician',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .white, // Make text white to be visible on dark overlay
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('images/dfperson.png') as ImageProvider,
                      child: _profileImage == null
                          ? Icon(Icons.camera_alt,
                              size: 30, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.phone,
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    obscureText: true,
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                          color: Colors.black), // Make label text white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Adjust fill color opacity
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    obscureText: true,
                    style:
                        TextStyle(color: Colors.black), // Make input text white
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Gender: ',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                          ),
                          Text('Male', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                          ),
                          Text('Female', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _errorMessage ?? '', // Show error message here
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createAccount,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
