import 'dart:typed_data';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/controllers/vendor_register_controller.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/utils/show_snackBar.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final VendorController _vendorController = VendorController();
  late String countryValue;
  late String cityValue;
  late String stateValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isGSTRegistered = false;
  Uint8List? _profileImage;
  Uint8List? _verificationDoc;
  bool _agreeToTerms = false;
 late String businessName;
 late String email;
 late String phoneNumber;
 late String streetAddress;
 late String pinCode;
 late String gstNumber;


  selectGalleryImage() async {
    Uint8List img =
    await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _profileImage = img;
    });
  }
  selectGalleryImageVerification() async {
    Uint8List verificationImg =
    await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _verificationDoc = verificationImg;
    });
  }
  selectCameraImage() async {
    Uint8List img =
    await _vendorController.pickStoreImage(ImageSource.camera);
    setState(() {
      _profileImage = img;
    });
  }
  _saveVendorDetails() async {
 EasyLoading.show(status: 'Please wait');
    if (_formKey.currentState!.validate()) {
      await _vendorController.registerVendor(
          businessName,
          email,
          phoneNumber,
          countryValue,
          stateValue,
          cityValue,
          streetAddress,
          pinCode,
          _isGSTRegistered ,
          gstNumber,
          _agreeToTerms ,
          _profileImage,
          _verificationDoc).whenComplete(() {
            EasyLoading.dismiss();
      });
    } else {
      showSnack(context, 'Fill all the required Fields');
      EasyLoading.dismiss();
      setState(() {
        _formKey.currentState!.reset();
        _profileImage =null;
        _verificationDoc=null;
        _agreeToTerms=false;
        _isGSTRegistered =false;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 200,
              flexibleSpace: LayoutBuilder(builder: (context, constraint) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.cyan, Colors.white]),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Make Your Store",style: TextStyle(
                            fontSize: 20
                          ),),
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _profileImage != null ? Image.memory(
                                _profileImage!) : IconButton(
                              onPressed: () {
                                selectGalleryImage();
                              },
                              icon: const Icon(CupertinoIcons.photo_camera),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text("Upload Store Image/Logo",
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value){
                          businessName=value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Store Name can not be empty!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Your Store Name',
                          prefixIcon: const Icon(Icons.store),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value){
                          email=value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email can not be empty!';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Store or Owners Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value){
                          phoneNumber=value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone Number can not be empty!';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Store or Owner Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value){
                          pinCode=value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'PinCode can not be empty!';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Your PinCode',
                          prefixIcon: const Icon(Icons.pin),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value){
                          streetAddress=value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Street Address can not be empty!';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Street Address',
                          prefixIcon: const Icon(Icons.location_history),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: SelectState(
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                        ),
                      ),


                      const SizedBox(height: 24,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Is your store GST Registered ?',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isGSTRegistered,
                                    onChanged: (value) {
                                      setState(() {
                                        _isGSTRegistered = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Yes'),
                                ],
                              ),
                            ],
                          ),
                          const Text(
                            "Click the checkbox if you have GST number",
                            style: TextStyle(color: Colors.cyan, fontSize: 12),)
                        ],
                      ),
                      const SizedBox(height: 12,),
                      if(_isGSTRegistered == true)
                        TextFormField(
                          onChanged: (value){
                            gstNumber=value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Enter GST Number',
                            prefixIcon: const Icon(Icons.numbers),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      // verification documents upload

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _verificationDoc != null ? Image.memory(
                                _verificationDoc!) : IconButton(
                              onPressed: () {
                                selectGalleryImageVerification();
                              },
                              icon: const Icon(CupertinoIcons.photo_camera),
                            ),
                          ),

                          const Text(
                              "Upload Document Image for verification. Accepted Documents are: Udyam Aadhar har, GST certificate, Current Account Cheque"),
                        ],
                      ),

                      Row(
                        children: [
                          Radio(
                            value: true,
                            groupValue: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value as bool;
                              });
                            },
                          ),
                          const Text('I agree to the Terms and Conditions'),
                        ],
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(

                          onPressed: _agreeToTerms ? () {
                            _saveVendorDetails();
                          } : null,
                          child: const Text(
                            'Register',
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
          ],
        ));
  }
}
