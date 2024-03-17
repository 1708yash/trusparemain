import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({Key? key}) : super(key: key);

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  late String vendorId;
  late String profileImage = ''; // Initialize with empty string
  late String businessName;
  late String email;
  late String streetAddress;
  late String cityValue;
  late String stateValue;
  late String countryValue;
  late String pinCode;

  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vendorId = FirebaseAuth.instance.currentUser!.uid;
    fetchVendorProfile();
  }

  Future<void> fetchVendorProfile() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('vendors').doc(vendorId).get();
      var data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        profileImage = data['profileImage'] ?? ''; // Handle case where profileImage is null
        businessName = data['businessName'];
        email = data['email'];
        streetAddress = data['streetAddress'];
        cityValue = data['cityValue'];
        stateValue = data['stateValue'];
        countryValue = data['countryValue'];
        pinCode = data['pinCode'];

        businessNameController.text = businessName;
        emailController.text = email;
        streetAddressController.text = streetAddress;
        cityController.text = cityValue;
        stateController.text = stateValue;
        countryController.text = countryValue;
        pinCodeController.text = pinCode;
      });
    } catch (e) {
      // Handle error silently
      print("Error fetching vendor profile: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
        'businessName': businessNameController.text,
        'email': emailController.text,
        'streetAddress': streetAddressController.text,
        'cityValue': cityController.text,
        'stateValue': stateController.text,
        'countryValue': countryController.text,
        'pinCode': pinCodeController.text,
      });

      fetchVendorProfile();
    } catch (e) {
      // Handle error silently
      print("Error updating vendor profile: $e");
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        String imageName = 'storeImage/$vendorId/${DateTime.now().millisecondsSinceEpoch}';
        await firebase_storage.FirebaseStorage.instance.ref(imageName).putFile(imageFile);

        String imageUrl = await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();

        await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
          'profileImage': imageUrl,
        });

        fetchVendorProfile();
      } catch (e) {
        // Handle error silently
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      uploadImage();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                      backgroundColor: Colors.grey[200],
                      child: profileImage.isEmpty ? Icon(Icons.person, size: 60, color: Colors.grey) : null,
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.cyan,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(businessNameController, 'Business Name'),
              const SizedBox(height: 16),
              _buildTextField(emailController, 'Email'),
              const SizedBox(height: 16),
              _buildTextField(streetAddressController, 'Street Address'),
              const SizedBox(height: 16),
              _buildTextField(cityController, 'City Name'),
              const SizedBox(height: 16),
              _buildTextField(stateController, 'State Name'),
              const SizedBox(height: 16),
              _buildTextField(countryController, 'Country Name'),
              const SizedBox(height: 16),
              _buildTextField(pinCodeController, 'PinCode'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
      ),
    );
  }
}
