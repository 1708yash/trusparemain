import 'package:flutter/material.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: const [
          SectionHeading('1. INFORMATION GATHERING'),
          SectionSubHeading('a. Truspare values the privacy of its users and has taken precautions to make sure it doesn\'t gather more data from them than is required in order to protect their accounts and offer their services.'),
          SectionSubHeading('b. When a user registers on the platform, information may be gathered about them, including but not limited to their name, address, phone number, fax number, email address, gender, date and/or year of birth, and preferences ("Registration Information").'),
          SectionSubHeading('c. To facilitate the sale and purchase as well as the settlement of the purchase price of the goods or services transacted on or obtained through the Platform, among other things, information, including but not limited to bank account numbers, billing and delivery information, credit/debit card numbers and expiration dates, and tracking information from checks or money orders ("Account Information"), may be collected in connection with any communication or transaction and payment services or any other services that you may avail using the Platform.'),
          SectionSubHeading('d. Details of User activity on the Platform are recorded and kept on file by Truspare. As and when the communication and/or transactions are carried out through the Platform, information pertaining to communication or transactions, such as the kinds and specifications of the goods, pricing and delivery information, any dispute records, and any information disclosed in any communication forum provided by us and/or other affiliated companies of Truspare, may be collected ("Activities Information").'),
          SectionSubHeading('e. In addition to IP addresses, browsing habits, and user behavior patterns, Truspare records and keeps track of users\' browsing and purchasing activity on the platform. Additionally, we collect statistical data about the Platform and its users, such as IP addresses, browser software, operating systems, hardware and software parameters, the number of sessions, unique visitors, pages seen, and so on (collectively, "Browsing Information").'),
          SectionSubHeading('f. User Data is the collective term for Registration Information, Account Information, Activities Information, and Browsing Information.'),
          SectionSubHeading('g. Users of the Platform are required to disclose specific categories of User Data. If Users do not supply any or all of the mandatory User Data, Truspare may be unable to finish the registration process or provide them with Truspare\'s products or services.'),
          SectionHeading('2. THE USE OF USER DATA'),
          SectionSubHeading('If you supply any User Data to Truspare, you are believed to have authorized us to collect, retain, and utilize the User Data for the following purposes:'),
          SectionSubHeading('a. Verification of the user\'s identity'),
          SectionSubHeading('b. Processing User registration as a user, giving User(s) with a log-in ID for the Platform, and maintaining and monitoring User registration;'),
          SectionSubHeading('c. Providing customer service to users and responding to their inquiries, feedback, claims, or disputes.'),
          SectionSubHeading('d. to facilitate user-to-user interactions and/or handle user transactions on the platform;'),
          SectionSubHeading('e. conducting research or statistical analysis for marketing and promotional reasons, to enhance Truspare\'s product and service offerings, and to improve the Platform\'s content and layout;'),
          SectionSubHeading('f. In accordance with applicable laws, Truspare (as well as our affiliated companies and their designated Service Providers) may use the user\'s name, contact information, residential address, email address, fax number, and other information (collectively, "Marketing Data") to send user(s) notices, surveys, product alerts, communications, and other marketing materials about Truspare\'s and its affiliated companies\' goods and services;'),
          SectionSubHeading('g. Users are considered to have consented to the publication of their information on the Platform if they freely submit any User(s) information or other information to the Platform for publication on the Platform through the publishing tools; and'),
          SectionSubHeading('h. giving any information that may be needed for the aforementioned reasons, as well as for legal, regulatory, and policy requirements, as well as for any investigations, claims, or prospective claims made against us or against third parties.'),
          SectionHeading('3. DISCLOSURE OF USER DATA'),
          SectionSubHeading('a. User(s) also agrees that Truspare may disclose and transfer User(s) Data to third-party service providers ("Service Providers"). These Service Providers have a duty of confidentiality to Truspare and are only entitled to use User(s) Data for the purposes mentioned in clause 2 above.'),
          SectionSubHeading('b. User(s) agree that Truspare may disclose and transfer User(s) Data to its associated organizations and/or designated Service Providers.'),
          SectionSubHeading('c. When necessary, Truspare may also give our professional advisors, law enforcement, insurance, government and regulatory agencies, and other organizations access to the User(s) Data.'),
          SectionSubHeading('d. Any User(s) Data that Users supply will be kept by Truspare and made available to our staff, any Service Providers that Truspare hires, and third parties mentioned in this paragraph 3 for any of the reasons listed in this clause 2 above.'),
          SectionSubHeading('e. Any voluntary information that users post or supply on the platform, including as items, pictures, comments, reviews, and so on, may be made publicly available so that anybody with an internet connection can see it. Any voluntarily provided information by the user to Truspare becomes public knowledge, and the user forfeits any property rights therein. When choosing to include private or confidential information in the voluntarily submitted information to Truspare or uploaded on the Platform, User(s) should proceed with prudence.'),
          SectionHeading('4. RIGHT TO UPDATE USER DATA'),
          SectionSubHeading('Users have the legal right to access personal data that Truspare holds about them and to request that the data be updated or corrected.'),
          SectionHeading('5. SECURITY MEASURES'),
          SectionSubHeading('In order to prevent unauthorized access to the Platform, maintain data accuracy, and guarantee the proper use of the information it contains, Truspare uses commercially reasonable security measures. It is impossible to guarantee complete security when sending data over the internet or any wireless network. Because of this, although if Truspare makes an effort to safeguard the data it has, it cannot ensure the security of any information users send to it, and users do so at their own risk.'),
          SectionHeading('6. DATA RETENTION'),
          SectionSubHeading('Truspare makes every effort to guarantee that the processing of the user\'s personal data is done so "as is." Via the Platform\'s capabilities, you can easily access, update, and rectify your personal information. By writing to us at the address listed below, you have the opportunity to revoke any consent you have already given. Kindly include "for withdrawal of consent" in the message\'s subject line. Before fulfilling your request, TRUSPARE will confirm such demands. However, please be aware that this consent withdrawal will not be retroactive and will be in compliance with the requirements of this Privacy Policy, any applicable laws, and related terms of use. If you withdraw the consent, you have granted us under this privacy policy, it may prevent you from using the Platform or limit the services we can provide to you for which we deem that information necessary.'),
          SectionHeading('7. USER`S RIGHT'),
          SectionSubHeading('Your personal information is retained by Truspare for the duration of time necessary to fulfill the purposes for which it was gathered or as mandated by any applicable legislation, in compliance with applicable laws. Nevertheless, Truspare is permitted to keep your personal information on file if it thinks it could be needed to stop fraud or other abuse, to exercise its legal rights and/or defend against legal claims, as required by law, or for other justifiable reasons. Your data may still be kept by Truspare in an anonymized format for analytical and research needs.'),
          SectionHeading('8. CHANGES TO THIS PRIVACY POLICY'),
          SectionSubHeading('We will notify you of any changes to this privacy statement by publishing a revised and restated version of it on the Platform. The updated Privacy Policy will take effect right away as it is posted on the Platform. You will be regarded to have accepted the terms of the Privacy Policy if you continue to use the Platform. The user(s) acknowledges that the most recent version of the privacy policy will apply to any information that Truspare may retain about them (as defined in this privacy policy, whether or not it was obtained before or after the revised privacy policy went into effect).'),

          SectionHeading('Return Policy'),
          SectionSubHeading('This Returns Policy (“Policy”) will govern request to return any of the product (“Product”) purchased by buyer (referred to as “Buyer”, you, your, etc.) from any third-party seller (“Seller”) using the Platform. For the purposes of this Policy, the term Buyer and Seller are collectively referred to as “User”.'),
          SectionSubHeading('• You understand that we are an intermediary platform and will only be responsible to mediate the return request raised by you with the Seller. It shall be sole responsibility of the Seller to resolve the issues/ concerns raised by you in your return request. We shall not assume any liability for any failure on the part of the Seller to resolve your issue.'),
          SectionSubHeading('• You may raise a return request/ or your concerns on the Platform with respect to any one of the following reasons:'),
          SectionSubHeading('1. Product with physical damage (if such damage is not in transit) or defective Product;'),
          SectionSubHeading('2. Warranty issues with respect to the Product;'),
          SectionSubHeading('3. Wrong Product or Product not matching the description or specifications mentioned on the listing page on the Platform;'),
          SectionSubHeading('4. Part of the order/ items are found to be missing (which is not due to logistics reasons); or'),
          SectionSubHeading('5. Issues related to the quality of the Product delivered.'),
          SectionSubHeading('You may raise a return request/ or your concerns on the Platform with respect to any one of the following reasons:'),
          SectionSubHeading('1. Product with physical damage (if such damage is not in transit) or defective Product;'),
          SectionSubHeading('2. Warranty issues with respect to the Product;'),
          SectionSubHeading('3. Wrong Product or Product not matching the description or specifications mentioned on the listing page on the Platform;'),
          SectionSubHeading('4. Part of the order/ items are found to be missing (which is not due to logistics reasons); or'),
          SectionSubHeading('5. Issues related to the quality of the Product delivered.'),
          SectionSubHeading('Any return request/ issues raised by you for any of the following reasons:'),
          SectionSubHeading('1. Missing Product or some items from the entire order placed found to be missing due to reasons attributable to logistics provider;'),
          SectionSubHeading('2. Damage to the outer box delivered or Product damaged in transit; or'),
          SectionSubHeading('3. Any other logistics related issues;'),
          SectionSubHeading('Will not be governed by this Policy and it will be the responsibility of your logistics partner to settle any of the above-mentioned concerns raised by you. You may contact your logistics service provider for resolving the above issues. It is hereby clarified that we shall not assume any responsibility for non- redressal of your issues by such logistics partner.'),
          SectionSubHeading('Your return request will either be approved or rejected and the same will be communicated to you.'),
          SectionSubHeading('If the return request of the Buyer has been rejected due to the following reasons that:'),
          SectionSubHeading('(a) Buyer does not respond to the inquiry calls and/or calls made by us to procure missing documentation and information; or'),
          SectionSubHeading('(b) supportive documents are insufficient, or Buyer is unable to provide sufficient proof in support of the claim, Buyer may raise a new return request within three (3) days from the date of such rejection.'),
          SectionSubHeading('If your return request is approved, it shall be your sole responsibility to return the Product directly to the Seller.'),
          SectionSubHeading('In all cases of Seller approved returns, refund will be initiated to you. On all Seller approved returns, we undertake no guarantee as regards return of monies or timeline for such return.'),
          SectionSubHeading('In exceptional cases such as fraud, deficiency in service, or any other circumstance which may affect the user experience on the platform, we may on good faith basis and in our sole discretion decide to pay the transaction amount for the disputed Product in the absence of Seller approval of such returns. The said payment of transaction amount shall be made to compensate for the inappropriate user experience.'),
          SectionSubHeading('In such exceptional cases, payment will be initiated to you within forty-eight (48) banking hours:'),
          SectionSubHeading('1. from the date of approval of the return request by us; or'),
          SectionSubHeading('2. from the date you confirm the dispatch of the Product from your shop/ designated pick-up location; whichever is later.'),
          SectionSubHeading('Upon receipt of shipment from the Buyer, Seller can raise a dispute with respect to the shipment within seventy-two (72) hours from receipt of the same, failing which it shall be deemed as accepted by the Seller without any damage or fault.'),
          SectionSubHeading('At the time of raising a dispute, Seller will be required to provide documents/ proof in support of the claim, which include without limitation, images of the returned product(s) indicating the issue in the shipment received. The images need to clearly capture the following:'),
          SectionSubHeading('1. the Return ID;'),
          SectionSubHeading('2. AWB number of the shipment;'),
          SectionSubHeading('3. issue observed by Seller in the returned product;'),
          SectionSubHeading('4. damages to the returned product;'),
          SectionSubHeading('5. brand name/ manufacturer’s name of the returned product; and/or'),
          SectionSubHeading('6. the IMEI number (in case the product is a mobile phone).'),
          SectionSubHeading('The Seller’s claim/ dispute will either be approved or rejected and the same will be communicated to the Seller.'),
          SectionSubHeading('Any capitalised terms used herein this Policy and not defined explicitly shall have the same meaning as defined in the Terms of Use.'),
          SectionSubHeading('User agrees to be bound to any changes or modifications made to this Policy as may be updated on the Platform, from time to time or any additional terms that may be communicated to you, from time to time.'),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String text;

  const SectionHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}

class SectionSubHeading extends StatelessWidget {
  final String text;

  const SectionSubHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
