import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to handle user signup
  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    String res = "Something went wrong";
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await sendEmailVerification();
      res = 'success';

    } catch (error) {

      res ='Could not sign-up';
      return res;
    }
    return res;
  }
  // Function to send email verification
  Future<String> sendEmailVerification() async {
    String res ="verification Email";
    try {
      User? user = _auth.currentUser;
      await user!.sendEmailVerification();
      res ='Verification Email Sent';
      return res;
    } catch (error) {
      res ='Could Not send Verification Email';
      return res;
    }
  }

  Future<String> signUpUsers(
      String fullName,
      String phoneNumber,
      Uint8List? image,
      bool agreeToTerms,
      ) async {
    String res = "Something went wrong";
    try {
      if (fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          image != null &&
          agreeToTerms) {
        // Get the current user ID
        String userId = _auth.currentUser!.uid;

        // Upload profile image
        String profileImageUrl = await _uploadProfileImageToStorage(image);

        // Set email verification to true for the newly created user

        res = 'success';
        await _firestore.collection('buyers').doc(userId).set({
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'buyerId': userId,
          'profileImage': profileImageUrl,
          'agreeToTerms': agreeToTerms,
        });
      } else {
        res = 'Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUsers(String email, String password) async {
    String res = 'Something went wrong';

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Check if email is verified
        if (userCredential.user!.emailVerified) {
          res = 'success'; // User is logged in
        } else {
          res = 'Email not verified. Please verify your email address.'; // Email not verified
        }
      } else {
        res = 'Failed to sign in';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<bool> checkCurrentUserInBuyers() async {
    String userId = _auth.currentUser!.uid;
    try {
      // Query buyers collection with the current user's ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('buyers').where('buyerId', isEqualTo: userId).get();

      // If there is at least one document with the user's ID, return true
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // If an error occurs during the query, return false
      print("Error checking current user in buyers: $e");
      return false;
    }
  }

  Future<String> _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
    _storage.ref().child('userProfilePics').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print("Image auth controller");
      return null;
    }
  }
}
