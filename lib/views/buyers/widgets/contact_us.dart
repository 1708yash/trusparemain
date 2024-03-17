import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mobile Number:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter your mobile number',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your problem here',
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitQuery,
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitQuery() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final mobileNumber = _mobileController.text.trim();
      final description = _descriptionController.text.trim();

      // Validate inputs
      if (mobileNumber.isEmpty || description.isEmpty) {
        _showSnackbar('Please fill all fields');
        return;
      }

      // Add query to Firebase collection
      try {
        await FirebaseFirestore.instance.collection('contactUs').add({
          'userId': userId,
          'mobileNumber': mobileNumber,
          'description': description,
          'timestamp': Timestamp.now(),
        });
        _showSnackbar('Query submitted successfully');
        _mobileController.clear();
        _descriptionController.clear();
      } catch (e) {
        _showSnackbar('Failed to submit query');
      }
    } else {
      _showSnackbar('User not authenticated');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
