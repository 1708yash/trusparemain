import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import '../pages/add_new_address.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewAddressScreen()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text('Saved Address'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text("Your Addresses"),
              SizedBox(height: 16),
              AddressDetailsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressDetailsList extends StatelessWidget {
  const AddressDetailsList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getAddressDetailsStream(), // Replace with your stream function
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading address details');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data?.docs;

        if (data == null || data.isEmpty) {
          return const Text('No address details found');
        }

        return Column(
          children: data.map((doc) {
            final streetAddress = doc['street'];
            final city = doc['city'];
            final state = doc['state'];
            final country = doc['country'];
            final pincode = doc['pincode'];

            return AddressDetailsCard(
              streetAddress: streetAddress,
              city: city,
              state: state,
              country: country,
              pincode: pincode,
            );
          }).toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot> getAddressDetailsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('buyers')
          .doc(user.uid)
          .collection('addresses')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }
}

class AddressDetailsCard extends StatelessWidget {
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String pincode;

  const AddressDetailsCard({
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    Key? key,
  }) : super(key: key);

  @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streetAddress,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('City: $city'),
                Text('State: $state'),
                Text('Country: $country'),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    'Pincode: $pincode',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
