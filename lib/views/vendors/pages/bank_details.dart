import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import 'add_back_details.dart';


class BankAccount extends StatelessWidget {
  const BankAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBankAccount()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text('Your Bank Details'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child:
          Column(
            children: [
              Text("Your Bank Accounts"),
              SizedBox(height: 16),
              BankDetailsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class BankDetailsList extends StatelessWidget {
  const BankDetailsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getBankDetailsStream(), // Replace with your stream function
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading bank details');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data?.docs;

        if (data == null || data.isEmpty) {
          return const Text('No bank details found');
        }

        return Column(
          children: data.map((doc) {
            final accountNumber = doc['accountNumber'];
            final bankName = doc['bankName'];
            final branch = doc['branch'];
            final upiId = doc['upiId'];

            return BankDetailsCard(
              accountNumber: accountNumber,
              bankName: bankName,
              branch: branch,
              upiId: upiId,
            );
          }).toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot> getBankDetailsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('vendors')
          .doc(user.uid)
          .collection('BankDetails')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }
}

class BankDetailsCard extends StatelessWidget {
  final String accountNumber;
  final String bankName;
  final String branch;
  final String upiId;

  const BankDetailsCard({
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.upiId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_balance),
                Text(
                  bankName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Account Number: $accountNumber'),
            Text('Branch: $branch'),
            Text('UPI ID: $upiId'),
          ],
        ),
      ),
    );
  }
}
