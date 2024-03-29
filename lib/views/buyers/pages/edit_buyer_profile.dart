import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class BuyerUpdateDetails extends StatefulWidget {
  const BuyerUpdateDetails({Key? key}) : super(key: key);

  @override
  _BuyerUpdateDetailsState createState() => _BuyerUpdateDetailsState();
}

class _BuyerUpdateDetailsState extends State<BuyerUpdateDetails> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  late String _profileImageUrl = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _currentUser = _auth.currentUser!;
    final userDataSnapshot = await _firestore
        .collection('buyers')
        .doc(_currentUser.uid)
        .get();

    if (userDataSnapshot.exists) {
      final userData = userDataSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _fullNameController.text = userData['fullName'] ?? '';
        _phoneNumberController.text = userData['phoneNumber'] ?? '';
        _profileImageUrl = userData['profileImage'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      final userData = {
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'profileImage': _profileImageUrl,
      };

      await _firestore
          .collection('buyers')
          .doc(_currentUser.uid)
          .update(userData);

      ScaffoldMessenger.of(context.mounted as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context.mounted as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
        ),
      );
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final fileName = 'userProfilePics/${_currentUser.uid}.jpg';
      final ref = _storage.ref().child(fileName);
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context.mounted as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload image'),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      _uploadImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        Navigator.pop(context);
        return ;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl)
                            : null,
                      ),
                      const Icon(
                        Icons.edit,
                        color: Colors.cyan,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  fillColor: Colors.white,
                  filled: false,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  fillColor: Colors.white,
                  filled: false,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
