class VendorUsersModels {
  final bool? agreeToTerms;
  final bool? approved;
  final String? businessName;
  final String? city;
  final String? country;
  final String? email;
  final String? gstNumber;
  final String? gstRegistration;
  final String? phoneNumber;
  final String? pinCode;
  final String? profileImage;
  final String? state;
  final String? streetAddress;
  final String? verificationDoc;

  VendorUsersModels({required this.agreeToTerms,
    required this.approved,
    required this.businessName,
    required this.city,
    required this.country,
    required this.email,
    required this.gstNumber,
    required this.gstRegistration,
    required this.phoneNumber,
    required this.pinCode,
    required this.profileImage,
    required this.state,
    required this.streetAddress,
    required this.verificationDoc});

  VendorUsersModels.fromJson(Map<String, Object?>json):this(
    agreeToTerms: json['agreeToTerms']!as bool,
        approved: json['approved']!as bool,
        businessName: json['businessName']!as String,
       city: json['city']!as String,
      country: json['country']!as String,
      email: json['email']!as String,
        gstNumber: json['gstNumber']!as String,
      gstRegistration: json['gstRegistration']!as String,
        phoneNumber: json['phoneNumber']!as String,
      pinCode: json['pinCode']!as String,
    profileImage: json['profileImage']!as String,
    state: json['state']!as String,
     streetAddress: json['streetAddress']!as String,
       verificationDoc: json['verificationDoc']!as String,
      );

  Map<String,Object?>toJson(){
    return {
      'agreeToTerms':agreeToTerms,
      'approved':approved,
      'businessName':businessName,
      'city':city,
      'country':country,
      'email':email,
      'gstNumber':gstNumber,
      'gstRegistration':gstRegistration,
      'phoneNumber':phoneNumber,
      'pinCode':pinCode,
      'profileImage':profileImage,
      'state':state,
      'streetAddress':streetAddress,
      'verificationDoc':verificationDoc,
    };
  }
}
