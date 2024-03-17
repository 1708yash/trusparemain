import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class AddBankAccountBuyer extends StatefulWidget {
  const AddBankAccountBuyer({Key? key}) : super(key: key);

  @override
  _AddBankAccountBuyerState createState() => _AddBankAccountBuyerState();
}

class _AddBankAccountBuyerState extends State<AddBankAccountBuyer> {
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addBankDetails() async {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        final QuerySnapshot buyerQuery = await _firestore
            .collection('buyers')
            .where('buyerId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (buyerQuery.docs.isNotEmpty) {
          final String buyerID = buyerQuery.docs.first.id;
          final CollectionReference bankDetailsCollection = _firestore
              .collection('buyers')
              .doc(buyerID)
              .collection('bankDetails');

          await bankDetailsCollection.add({
            'accountNumber': _accountNumberController.text,
            'bankName': _bankNameController.text,
            'branch': _branchController.text,
            'upiId': _upiIdController.text,
            // Add other bank details fields as needed
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank details added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.pop(context);
        } else {
          print('Buyer not found for the current user.');
          // Handle case where buyer is not found
        }
      } else {
        print('User not logged in.');
        // Handle case where user is not logged in
      }
    } catch (e) {
      print('Error adding bank details: $e');
      // Handle error adding bank details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bank Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Add bank account details here"),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Account Number',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _branchController,
                  decoration: const InputDecoration(
                    labelText: 'Branch',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _upiIdController,
                  decoration: const InputDecoration(
                    labelText: 'UPI ID',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        addBankDetails();
                      }
                    },
                    child: const Text(
                      'Add Bank Details ',
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
}
