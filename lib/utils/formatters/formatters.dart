import 'package:intl/intl.dart';

class YFormatter{
  static String formatDate(DateTime? date){
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount){
    return NumberFormat.currency(locale: 'en_US',symbol: '\$').format(amount); // customize the time currency or time simply according to the timezone
  }

  static String formatPhoneNumber(String phoneNumber){
    // using 10 digit phone number
    if(phoneNumber.length==10){
      return '${phoneNumber.substring(0,3)} ${phoneNumber.substring(3,6)} ${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }

  // international numbers (not made yet)

static String internationalFormatPhoneNumber(String phoneNumber){
    // remove all the non number digits
  var digitOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
// country codes
  String countryCode = '+${digitOnly.substring(0,2)}';
  digitOnly = digitOnly.substring(2);

  // rest of the phone number
  final formattedNumber = StringBuffer();
  formattedNumber.write('($countryCode)');

  int i=0;
  while(i<digitOnly.length){
    int groupLength =2;
    if(i==0 && countryCode=='+1'){
      groupLength =3;
    }
    int end =i +groupLength;
    formattedNumber.write(digitOnly.substring(i,end));

    if(end<digitOnly.length){
      formattedNumber.write(' ');
    }
    i =end;
  }
  return phoneNumber;
}
}