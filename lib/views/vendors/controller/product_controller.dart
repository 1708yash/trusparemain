import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? fileName;


  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      final Reference storageReference = _storage
          .ref()
          .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageReference.putData(imageBytes);
      await uploadTask;
      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }


  uploadProductToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('products').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addProduct({
    required String productTitle,
    required String productDescription,
    required String priceOfOneItem,
    required String minimumQuantity,
    required String category,
    required String subCategory,
    required String superSubCategory,
    required String imageDownloadURL,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final QuerySnapshot vendorQuery = await _firestore
            .collection('vendors')
            .where('VendorID', isEqualTo: user.uid)
            .limit(1)
            .get();
        if (vendorQuery.docs.isNotEmpty) {
          final String vendorID = vendorQuery.docs.first.id;

          // Add product to vendor's sub-collection
          final CollectionReference vendorProductsCollection = _firestore
              .collection('vendors')
              .doc(vendorID)
              .collection('products');
          final DocumentReference newProductRef = vendorProductsCollection.doc();

          await newProductRef.set({
            'productID': newProductRef.id, // Set the productID field
            'productTitle': productTitle,
            'productDescription': productDescription,
            'priceOfOneItem': priceOfOneItem,
            'minimumQuantity': minimumQuantity,
            'category': category,
            'subCategory': subCategory,
            'superSubCategory': superSubCategory,
            'imageURL': imageDownloadURL,
            'approved': false, // New 'approved' field
            'vendorID': user.uid,
          });

          // Add product to general 'products' collection
          final CollectionReference productsCollection =
          _firestore.collection('products');
          await productsCollection.doc(newProductRef.id).set({
            'productID': newProductRef.id,
            'vendorID': vendorID,
            'productTitle': productTitle,
            'productDescription': productDescription,
            'priceOfOneItem': priceOfOneItem,
            'minimumQuantity': minimumQuantity,
            'category': category,
            'subCategory': subCategory,
            'superSubCategory': superSubCategory,
            'imageURL': imageDownloadURL,
            'approved': false, // New 'approved' field
          });

          // Successfully added the product, you can add any additional logic here
        } else {
          print('Vendor not found for the current user.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('Failed to add product');
    }
  }

  pickStoreImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No image Selected');
    }
  }

}
