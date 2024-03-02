import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/utils/show_snackBar.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerWithEmailAndPassword(String fullName, String email,
      String phoneNumber, String password) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'buyerId': userCredential.user!.uid,
        'address': "",
      });
      // You can also save additional user data to Firebase Firestore or Realtime Database here
    } catch (e) {
      // Handle registration errors
      print("Registration Error: $e");
      rethrow; // You can handle the error according to your application's needs
    }
  }

  loginUsers(String email, String password) async {
    String res = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  pickProfileImage(ImageSource source)async{
final ImagePicker imagePicker =ImagePicker();
 XFile? file = await imagePicker.pickImage(source: source);

 if(file!=null){
   return await file.readAsBytes();
 }else{
  print("no image was pickup");
 }
  }
}
