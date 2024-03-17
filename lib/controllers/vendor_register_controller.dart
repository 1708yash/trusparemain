import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// function to store Image
  pickStoreImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image Selected');
    }
  }

  // verification document
  verificationDoc(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image Selected');
    }
  }

  // function to store image on firestore

  _uploadVendorImageToStore(Uint8List? profileImage) async {
    Reference ref =
    _storage.ref().child('storeImage').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(profileImage!);
    await uploadTask;
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _uploadVendorVerificationToStore(Uint8List? verificationDocUpload) async {
    Reference ref =
    _storage.ref().child('VerifyDocuments').child(_auth.currentUser!.uid);
    UploadTask uploadtask = ref.putData(verificationDocUpload!);
    TaskSnapshot snapshot = await uploadtask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // function to pick store data
  // Function to sign up users with email and password
  Future<String> signUpUsers(
      String businessName,
      String email,
      String phoneNumber,
      String countryValue,
      String stateValue,
      String cityValue,
      String streetAddress,
      String pinCode,
      bool isGSTRegistered,
      String gstNumber,
      bool agreeToTerms,
      Uint8List? profileImage,
      Uint8List? verificationDoc,
      String password,
      ) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty &&
          businessName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          profileImage != null &&
          verificationDoc != null &&
          countryValue.isNotEmpty &&
          stateValue.isNotEmpty &&
          cityValue.isNotEmpty &&
          streetAddress.isNotEmpty &&
          agreeToTerms) {
        // Create user with email and password
        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Send email verification
        await cred.user!.sendEmailVerification();
        // Upload profile image and verification document
        final String profileImageUrl = await _uploadVendorImageToStore(profileImage);
        final String verificationDocUrl = await _uploadVendorVerificationToStore(verificationDoc);
        // Save user details to Firestore
        await _firestore.collection('vendors').doc(cred.user!.uid).set({
          'businessName': businessName,
          'email': email,
          'phoneNumber': phoneNumber,
          'countryValue': countryValue,
          'stateValue': stateValue,
          'cityValue': cityValue,
          'streetAddress': streetAddress,
          'pinCode': pinCode,
          'isRegisteredToGst': isGSTRegistered,
          'gstNumber': gstNumber,
          'agreeToTerms': agreeToTerms,
          'profileImage': profileImageUrl,
          'verificationDoc': verificationDocUrl,
          'VendorID': cred.user!.uid,
        });
        res = 'success';
      } else {
        res = 'Fields must not be empty';
      }
    } catch (e) {
      res = 'Verification Email Sent Verify your email to login';
    }
    return res;
  }
}