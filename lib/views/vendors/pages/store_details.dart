import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key});

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  late String vendorId;
  late String profileImage;
  late String businessName;
  late String email; // Newly added field
  late String streetAddress;
  late String cityValue;
  late String stateValue;
  late String countryValue;
  late String pinCode;

  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController(); // Newly added controller
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
        profileImage = data['profileImage'];
        businessName = data['businessName'];
        email = data['email']; // Newly added field
        streetAddress = data['streetAddress'];
        cityValue = data['cityValue'];
        stateValue = data['stateValue'];
        countryValue = data['countryValue'];
        pinCode = data['pinCode'];

        businessNameController.text = businessName;
        emailController.text = email; // Newly added controller
        streetAddressController.text = streetAddress;
        cityController.text = cityValue;
        stateController.text = stateValue;
        countryController.text = countryValue;
        pinCodeController.text = pinCode;
      });
    } catch (e) {
      print("Error fetching vendor profile: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
        'businessName': businessNameController.text,
        'email': emailController.text, // Newly added field
        'streetAddress': streetAddressController.text,
        'cityValue': cityController.text,
        'stateValue': stateController.text,
        'countryValue': countryController.text,
        'pinCode': pinCodeController.text,
        // Add other fields as needed
      });

      // Optionally, you can fetch the updated data again
      // to reflect the changes in the UI
      fetchVendorProfile();
    } catch (e) {
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

        // Optionally, you can fetch the updated data again
        // to reflect the changes in the UI
        fetchVendorProfile();
      } catch (e) {
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
              // Display the profile image with an edit icon
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    profileImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  InkWell(
                    onTap: () {
                      uploadImage();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Background color
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Display the business name with an edit icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: businessNameController,
                      decoration: const InputDecoration(
                        labelText: 'Business Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 16),
              // Display the email with an edit icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Add other fields similar to the business name
              // ...

              // Continue adding similar sections for the other fields
              // ...
              // street address
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: streetAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Edit Street Address',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
// city edit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Edit City Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // state edit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'Edit State Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 16),
              // country edit
              // country edit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: countryController,
                      decoration: const InputDecoration(
                        labelText: 'Edit Country Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // country edit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: pinCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Edit PinCode',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the logic for editing the business name
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
