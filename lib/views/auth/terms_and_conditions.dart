import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TERMS OF USE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Before moving forward, please carefully read the terms. DO NOT ACCESS OR USE THE PLATFORM OR SERVICES PROVIDED BY THE PLATFORM OR TRUSPARE IF YOU DO NOT AGREE TO ALL OF THESE TERMS. By accepting these Terms, either explicitly or implicitly, You also agree to be bound by any updates, modifications, and amendments to the Terms as well as any other policies (such as the Privacy Policy), as may be updated, modified, and amended from time to time.",
              ),
              SizedBox(height: 20),
              Text(
                "I. GENERAL TERMS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. EFFECTIVE DATE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "On 1st of January, 2024, at 0000 hours, these terms of use will be operative.",
              ),
              SizedBox(height: 10),
              Text(
                "2. APPLICATION AND ACCEPTANCE OF THE TERMS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "a. Terms and conditions in this document and the Privacy Policy apply to your use of the Platform and TRUSPARE`s services, features, functionality, software, and products (collectively referred to as the 'Services' below).",
              ),
              Text(
                "b. You must read TRUSPARE Privacy Policy which governs the collection, use, and disclosure of personal information about Users. You accept the terms of the Privacy Policy and agree to the use of the personal information about you in accordance with the Privacy Policy.",
              ),
              // Add other sections of the terms similarly
              SizedBox(height: 20),
              Text(
                "3. PROVISION OF SERVICES",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "a. To access and utilize the Services, you need to register on the Platform. In addition, TRUSPARE retains the right to impose additional terms and conditions at its sole discretion, including the right to prohibit access to or use of any features within the Services, all without prior notice.",
              ),
              Text(
                "b. If you use the Platform to access services that are offered by third party service provider(s), your contracting entity will be the applicable third party service provider(s) for all of those services. Any claims arising from your use of services rendered by such third-party service provider(s) are disclaimed by TRUSPARE.",
              ),
              Text(
                "c. The user acknowledges and agrees that TRUSPARE is providing you with the Services on a best effort basis and that TRUSPARE may use the services of one or more third-party service providers to make these Services available to you. We will not be responsible to you in any way for any failure or delay on our part to provide the Services, or for any temporary or permanent discontinuance of the Services, or for any consequences that may arise from such acts or from causes without of our reasonable control.",
              ),
              Text(
                "d. The user understands that while using, browsing, transacting, or posting content on the Platform, there may be interruptions and that the Services are being offered to you \"as is\" and \"as available.\" User acknowledges that we reserve the right, at our sole discretion, to immediately discontinue the Services without providing any explanation.",
              ),
              Text(
                "e. Anytime, with or without prior warning, TRUSPARE has the right to withdraw, terminate, and/or suspend all or part of the Services for any reason, including when a User violates the Terms. Additionally, the provision of other services, as well as any commercial agreements or arrangements the User may have engaged into with TRUSPARE, will not be impacted by the termination of all or part of the Services.",
              ),
              SizedBox(height: 20),
              Text(
                "4. ELIGIBILITY",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "In accordance with these terms, \"persons\" refers to any individual, business, corporation, government, state, or agency of a state, as well as associations, trusts, joint ventures, consortiums, partnerships, and other legally recognized bodies corporate that have been duly incorporated under Indian law.",
              ),
              Text(
                "The Platform may only be used by the User for business purposes; the User may not use the Platform or its Services for personal purposes.",
              ),
              SizedBox(height: 20),
              Text(
                "5. USER ACCOUNTS AND VERIFICATION OF ACCOUNT",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "a. To use the Services for business purposes, a user has to register on the Platform. You understand and agree that you will only use the Platform for business transactions, not for personal use. One User may only create one account on the Platform, unless authorized by TRUSPARE. If TRUSPARE has cause to believe that a user has registered for or been in control of two or more accounts simultaneously, TRUSPARE may cancel or terminate the user's account. In addition, TRUSPARE has the right to refuse a user's registration application for any other reason without providing a reason.",
              ),
              Text(
                "b. A single account has its own set of user IDs and OTPs (one-time passwords). Any action taken via your unique OTP or through your user account on the Platform will be considered authorized by you and your express consent. You alone are in charge of protecting the privacy and security of your password and user ID, as well as any activity that takes place on your account. You acknowledge that any actions taken under your account—such as, but not limited to, uploading information about your company or products, clicking to accept terms and conditions or guidelines, purchasing any services, sending emails through the Platform, or engaging in other correspondence—will be taken as permission from",
              ),
              Text(
                  "c.	You are electronically communicating with TRUSPARE when you use the Platform. TRUSPARE may contact you by phone calls, emails, SMS, WhatsApp messages, or other messaging services; additionally, TRUSPARE may post notices on the Platform, send in-app notifications, or use any other kind of communication. Regarding your use of the Platform, you agree and consent to receive communications from TRUSPARE in the manner described above, including transactional, promotional, and/or commercial messages. Your continued use of the Platform will be interpreted as your agreement to receive communications from TRUSPARE. "),
              // Continue adding other sections similarly

              Text(
                  "d.	You will be asked to provide information about yourself and your business when registering for a user account on the platform. This information may include your business name, GSTIN, PAN, TAN, Udyog Aadhar, address, phone number, and/or any other details that TRUSPARE may need to know about your business. You understand and agree that we may verify the information you submit on the Platform either directly or through a third-party service provider. You consent to providing us with further information and supporting documentation as we may occasionally need it in order to verify the details associated with your user account. We reserve the right to periodically ask for further information from you about yourself and your company, and you agree to submit it in order to use the Platform going forward. We maintain the right to periodically request further information from you about yourself and your company, and you agree to submit it in order to use the Platform going forward. We retain the right to periodically request more information from you about yourself and your company, and by using the Platform, you agree to furnish us with this extra information. "),
              Text(
                "6.	USERS GENERALLY",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  "a. You consent to the following: (a) you will not use any Services or information, text, images, graphics, video clips, sound, directories, files, databases, listings, etc. that is made available on or through the Platform (collectively, the Platform Content); (b) you will not use any Platform Content in any way to operate a business in direct competition with TRUSPARE or in any other way that involves the commercial exploitation of the Platform Content; or (c) you will not use any Platform Content in any way that would require permission from the Platform owner."),

              Text(
                  "b.	Through hyperlinks (word links, banners, channels, or other linkages), APIs, or other means to the websites of such third parties, TRUSPARE may grant Users access to material, goods, or services provided by third parties. Before utilizing the Platform in relation to any material, goods, or services you may use, you are advised to review the terms and conditions and/or privacy policies of such third parties. You understand that TRUSPARE has no control over the websites of these third parties and that it will not be held accountable or liable to anybody for these websites, or for any materials, goods, or services that are made accessible on them."),

              Text(
                  "c.	You promise not to do anything that could jeopardize the accuracy of TRUSPARE's feedback system."),
              Text(
                  "d.	You acknowledge that you will only use the Services for business purposes, such as purchasing goods to resell or distribute further. Additionally, you consent to not using the Platform or any of its services for your own consumption or usage."),
              Text(
                  "e.	You grant TRUSPARE a perpetual, worldwide, royalty-free, and sublicensable license to display, transmit, distribute, reproduce, publish, translate, and otherwise use any or all of the User Content in any form, media, or technology now known or not currently known in any manner and for any purpose that may be beneficial to the operation of the Platform, the provision of any Services, and/or the User's business by posting or displaying any information, content, or material (collectively, User Content) on the Platform, or by sending any User Content to TRUSPARE or our representative(s). You certify and guarantee to TRUSPARE that you possess all the authorization, capability, and power required to give the aforementioned license."),

              Text(
                'f. User acknowledges, undertakes, and agrees that the following legally enforceable principles will strictly regulate User\'s usage of the Platform:',

              ),
              SizedBox(height: 8),
              Text(
                'i. The following information cannot be hosted, displayed, uploaded, altered, published, transmitted, stored, updated, or shared by the user:',

              ),
              SizedBox(height: 8),
              Text(
                '1. is owned by someone else and over which the user has no legal authority;',
              ),
              // Add the rest of the numbered list items similarly
              SizedBox(height: 8),
              Text(
                'ii. It is forbidden to access, acquire, copy, or monitor any portion of the Platform or its content through the use of any "deep-link," "page-scrape," "robot," "spider," or other automatic device, program, algorithm, or methodology, or any comparable or equivalent manual process. You may also not replicate or evade the Platform\'s navigational structure or presentation in any way, nor attempt to obtain any materials, documents, or information through any means that is not intentionally made available through the Platform. TRUSPARE maintains the right to prohibit any such behavior.',
              ),
              SizedBox(height: 8),
              // Add the remaining sections in a similar manner
              Text(
                'iii. It is forbidden for you to use any terms related to TRUSPARE, such as "TRUSPARE Express," "TRUSPARE," or "TRUSPARE.com," or to make any other statements that could harm TRUSPARE\'s standing or reputation among users on the platform, or that could damage or dilute any of TRUSPARE\'s trademarks, service marks, trading name, or the goodwill associated with them.',
              ),
              SizedBox(height: 8),
              Text(
                'iv. You must always make sure that the Information Technology Act of 2000 and its rules, as well as any applicable and periodically modified regulations, are fully followed.',
              ),
              SizedBox(height: 8),
              Text(
                'v. The user agrees not to use hacking, password "mining," or any other illegal methods to attempt to obtain unauthorized access to any part of the platform, any other systems or networks connected to the platform, any server, computer, network, or any of the services provided on or through the platform.',
              ),
              SizedBox(height: 8),
              Text(
                'vi. User may not circumvent security or authentication mechanisms on the Platform or any network linked to the Platform, nor may they probe, scan, or test the vulnerability of the Platform or any network connected to the Platform, unless specifically authorized by the Platform. In order to prevent any information from being revealed—including, but not limited to, personal identification or information—other than User\'s own information, as provided by the Platform, User may not reverse look-up, trace, or attempt to trace any information on any other User or visitor to the Platform, or any other User, including any account on the Platform that User does not own, to its source. Neither may User exploit the Platform or any service or information made available or offered by or through the Platform.',
              ),
              SizedBox(height: 8),
              Text(
                'vii. Each User agrees to hold TRUSPARE, its affiliates, directors, employees, agents, and representatives harmless and to indemnify them for any and all damages, losses, claims, and liabilities (including legal costs on a full indemnity basis) that may arise from or in connection with: (i) your submission, posting, or display of any User Content; (ii) your use of the Platform or Services; (iii) your breach of the Terms or any applicable laws, including tax laws; (iv) any service you receive from a third party service provider using any dispute between Users; and/or (vi) your carelessness or intentional misconduct.',
              ),
              SizedBox(height: 8),
              Text(
                'g. It is your responsibility to make sure that you, your workers, subcontractors, service providers, and other parties always abide by the relevant anti-human trafficking and modern slavery legislation that are in effect and that are listed in the Code of Conduct.',
              ),
              SizedBox(height: 8),
              Text(
                'h. More specifically, you must make sure that: (i) you do not, directly or indirectly, use forced labor, bonded labor, human trafficking, or require contractors, employees, etc. to maintain monetary deposits or safekeep any identity documents as terms of their service with you; (ii) you do not, directly or indirectly, employ child labor, and all of your employees are above the minimum legal age; (iii) you provide fair wages and fair working conditions to your employees; (iv) you are an equal opportunity employer and do not discriminate on the basis of gender, race, religion, caste, or any other socioeconomic background; and (v) you respect the employees\' right to freedom of association; (vi) Your workers are free to quit their jobs at any time and are not being forced to work against their will; and (vii) Your workers have a sufficient grievance procedure in place to voice any concerns they may have about modern slavery.',
              ),
              SizedBox(height: 8),
              Text(
                'i. TRUSPARE reserves the right to conduct a specific audit of you to make sure that these modern slavery standards are being followed.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
