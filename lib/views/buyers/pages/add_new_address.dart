import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  @override
  _NewAddressScreenState createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12,),
                // Add form fields for street address, city, state, country, and pincode
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: 'Street Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pincode';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Add button to submit the form
            Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    // If the form is valid, submit the data to Firebase
                    _addAddressToFirebase();
                  }
                },
                child: const Text(
                  'Add New Address',
                  style: TextStyle(
                    color: Colors.white              ,
                    fontSize: 19,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addAddressToFirebase() async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    // Check if the user is logged in
    if (uid != null) {
      // Construct the data to be added to the sub-collection
      Map<String, dynamic> addressData = {
        'street': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
        'pincode': _pincodeController.text,
      };

      try {
        // Add the data to the 'addresses' sub-collection under the buyer's collection
        await FirebaseFirestore.instance
            .collection('buyers')
            .doc(uid)
            .collection('addresses')
            .add(addressData);

        // Optional: You can add more logic or navigate to a different screen upon success
        // ...

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (error) {
        // Handle errors if necessary
        print('Error adding address: $error');
      }
    }
  }
}
