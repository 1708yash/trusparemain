import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import 'add_bank_details.dart';

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
          child: Column(
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
  const BankDetailsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getBankDetailsStream(),
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final accountNumber = data[index]['accountNumber'];
            final bankName = data[index]['bankName'];
            final branch = data[index]['branch'];
            final upiId = data[index]['upiId'];
            final accountHolderName = data[index]['accountHolderName'];
            final ifscCode = data[index]['ifscCode'];

            return BankDetailsCard(
              accountNumber: accountNumber,
              bankName: bankName,
              branch: branch,
              upiId: upiId,
              accountHolderName: accountHolderName,
              ifscCode: ifscCode,
            );
          },
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
  final String accountHolderName;
  final String ifscCode;

  const BankDetailsCard({
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.upiId,
    required this.accountHolderName,
    required this.ifscCode,
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
            Text('Account Holder Name: $accountHolderName'),
            Text('IFSC Code: $ifscCode'),
          ],
        ),
      ),
    );
  }
}
