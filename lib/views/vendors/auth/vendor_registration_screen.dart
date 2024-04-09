import 'dart:typed_data';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/controllers/vendor_register_controller.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/utils/show_snackBar.dart';
import 'package:trusparemain/views/buyers/main_screen.dart';
import '../../auth/terms_and_conditions.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final VendorController _vendorController = VendorController();
  late String countryValue = '';
  late String cityValue = '';
  late String stateValue = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isGSTRegistered = false;
  Uint8List? _profileImage;
  Uint8List? _verificationDoc;
  bool _agreeToTerms = false;
  late String businessName = '';
  late String email = '';
  late String streetAddress = '';
  late String pinCode = '';
  late String gstNumber = '';
  late String mov ='';

  Future<void> selectGalleryImage() async {
    final Uint8List? img =
        await _vendorController.pickStoreImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _profileImage = img;
      });
    }
  }

  Future<void> selectGalleryImageVerification() async {
    final Uint8List? verificationImg =
        await _vendorController.pickStoreImage(ImageSource.gallery);
    if (verificationImg != null) {
      setState(() {
        _verificationDoc = verificationImg;
      });
    }
  }

  Future<void> _saveVendorDetails() async {
    if (_formKey.currentState!.validate()) {
      final String result = await _vendorController.signUpVendor(
        businessName,
        email,
        countryValue,
        stateValue,
        cityValue,
        streetAddress,
        pinCode,
        _isGSTRegistered,
        gstNumber,
        _agreeToTerms,
        _profileImage,
        _verificationDoc,
        mov,
      );

      if (result == 'success') {
        showSnack(context,
            'Congratulations Store Created');

        // Navigate landing page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen()),
        );
      } else {
        showSnack(context, 'Error: $result');
      }
    } else {
      showSnack(context, 'Fill all the required Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TermsAndConditions()),
            );
          },
          child: const Text('Terms and Conditions *'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(builder: (context, constraint) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.cyan, Colors.white]),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Make Your Store",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _profileImage != null
                              ? Image.memory(_profileImage!)
                              : IconButton(
                                  onPressed: selectGalleryImage,
                                  icon: const Icon(CupertinoIcons.photo_camera),
                                ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Upload Store Image/Logo",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )
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
                      onChanged: (value) {
                        businessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Store Name can not be empty!';
                        }
                        return null;
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
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
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
                      onChanged: (value) {
                        streetAddress = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Street Address can not be empty!';
                        }
                        return null;
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
                    TextFormField(
                      onChanged: (value) {
                        pinCode = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'PinCode can not be left empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'PinCode',
                        prefixIcon: const Icon(Icons.pin_drop),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onChanged: (value) {
                        mov = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a minimum order value';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter minimum order Value',
                        prefixIcon: const Icon(Icons.money),
                        border: OutlineInputBorder(
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
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
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
                          "Click the checkbox if you have any of the id available !",
                          style: TextStyle(color: Colors.cyan, fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isGSTRegistered == true)
                      TextFormField(
                        onChanged: (value) {
                          gstNumber = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Document ID Number',
                          prefixIcon: const Icon(Icons.numbers),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
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
                          child: _verificationDoc != null
                              ? Image.memory(_verificationDoc!)
                              : IconButton(
                                  onPressed: selectGalleryImageVerification,
                                  icon: const Icon(CupertinoIcons.photo_camera),
                                ),
                        ),
                        const Text(
                          "Upload Document Image for verification. Accepted Documents are: Udyam Aadhar har, GST certificate, Current Account Cheque",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        const Text('I agree to the Terms and Conditions'),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: _agreeToTerms ? _saveVendorDetails : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.cyan.shade400),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Create My Store',
                          textAlign: TextAlign.center,
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
      ),
    );
  }
}
