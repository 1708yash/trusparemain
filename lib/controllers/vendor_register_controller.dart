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

  _uploadVendorImageToStore(
      Uint8List? profileImage) async{
    Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(profileImage!);
    await uploadTask;
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl =await snapshot.ref.getDownloadURL();
return downloadUrl;
  }

  _uploadVendorVerificationToStore( Uint8List? verificationDocUpload)async{
   Reference ref= _storage.ref().child('VerifyDocuments').child(_auth.currentUser!.uid);
    UploadTask uploadtask = ref.putData(verificationDocUpload!);
   TaskSnapshot snapshot = await uploadtask;
   String downloadUrl =await snapshot.ref.getDownloadURL();
   return downloadUrl;
  }

  // function to pick store data
  Future<String> registerVendor(
    String businessName,
    String email,
    String phoneNumber,
    String country,
    String state,
    String city,
    String streetAddress,
    String pinCode,
    gstRegistered,
    String gstNumber,
     agreeToTerms,
    Uint8List? profileImage,
    Uint8List? verificationDocUpload,
  ) async {
    String res = 'some error occurred';

    try {
      {
       String storeImage= await _uploadVendorImageToStore(profileImage);
       String verificationDocument= await _uploadVendorVerificationToStore(verificationDocUpload);

        await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set(
            {
              'businessName':businessName,
              'email':email,
              'phoneNumber':phoneNumber,
              'country':country,
              'state':state,
              'city':city,
              'streetAddress':streetAddress,
              'pinCode':pinCode,
              'gstRegistered':gstRegistered,
              'gstNumber':gstNumber,
              'agreeToTerms':agreeToTerms,
              'profileImage':storeImage,
              'verificationDoc':verificationDocument,
              'approved':false,
            });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
