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

                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _addAddressToFirebase();
                      }
                    },
                    child: const Text(
                      'Add New Address',
                      style: TextStyle(
                        color: Colors.white,
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
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        String addressId = FirebaseFirestore.instance.collection('addresses').doc().id;

        Map<String, dynamic> addressData = {
          'street': _streetController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'pincode': _pincodeController.text,
        };

        Map<String, dynamic> buyerAddressData = {
          ...addressData,
          'addressId': addressId,
        };

        await FirebaseFirestore.instance
            .collection('buyers')
            .doc(uid)
            .collection('addresses')
            .doc(addressId)
            .set(buyerAddressData);

        await FirebaseFirestore.instance.collection('addresses').doc(addressId).set(addressData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address added successfully')),
        );

        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding address: $error')),
        );
      }
    }
  }
}
