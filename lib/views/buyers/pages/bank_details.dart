import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/add_bank_details.dart';

class BankDetails extends StatelessWidget {
  const BankDetails({Key? key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBankAccountBuyer()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
        title: const Text('Your Bank Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('buyers')
            .doc(userId)
            .collection('bankDetails')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bank details found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final bankDetail = snapshot.data!.docs[index];
              return BankDetailCard(
                accountNumber: bankDetail['accountNumber'],
                bankName: bankDetail['bankName'],
                branch: bankDetail['branch'],
                upiId: bankDetail['upiId'],
                onDelete: () {
                  // Delete the bank detail entry when the delete icon is clicked
                  FirebaseFirestore.instance
                      .collection('buyers')
                      .doc(userId)
                      .collection('bankDetails')
                      .doc(bankDetail.id)
                      .delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BankDetailCard extends StatelessWidget {
  final String accountNumber;
  final String bankName;
  final String branch;
  final String upiId;
  final VoidCallback onDelete;

  const BankDetailCard({
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.upiId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(accountNumber),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bank: $bankName'),
            Text('Branch: $branch'),
            Text('UPI ID: $upiId'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
