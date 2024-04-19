import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to pick/store image
  Future<Uint8List?> pickStoreImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image selected');
      return null;
    }
  }

  // Function to pick/store verification document
  Future<Uint8List?> verificationDoc(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image selected');
      return null;
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImageToStorage(Uint8List image, String folderName) async {
    try {
      Reference ref = _storage.ref().child('userProfilePics').child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to Storage: $e');
      return null;
    }
  }


  // Function to sign up users
  Future<String> signUpVendor(
      String businessName,
      String email,
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
      String mov,
      ) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated');
      }

      if (businessName.isEmpty ||
          email.isEmpty ||
          countryValue.isEmpty ||
          stateValue.isEmpty ||
          cityValue.isEmpty ||
          streetAddress.isEmpty ||
          pinCode.isEmpty ||
          profileImage == null ||
          verificationDoc == null ||
          !agreeToTerms) {
        throw Exception('All fields must be filled');
      }

      // Upload images to storage
      final String? profileImageUrl = await _uploadImageToStorage(profileImage, 'storeImage');
      final String? verificationDocUrl = await _uploadImageToStorage(verificationDoc,'VerifyDocuments');

      if (profileImageUrl == null || verificationDocUrl == null) {
        throw Exception('Failed to upload images');
      }

      // Save vendor details to Firestore
      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'email': email,
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
        'VendorID':_auth.currentUser?.uid,
        'verified': false,
        'mov': mov,
      });

      return 'success';
    } catch (e) {
      print('Error signing up vendor: $e');
      return 'Error: $e';
    }
  }
}
