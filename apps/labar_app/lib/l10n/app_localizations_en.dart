// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Labar Grains';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get createAccount => 'Create Account';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get signInTitle => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to access your dashboard';

  @override
  String get signUpTitle => 'Create Account';

  @override
  String get signUpSubtitle => 'Join us and start your journey';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a recovery code';

  @override
  String get verifyCodeTitle => 'Verify Code';

  @override
  String verifyCodeSubtitle(String email) {
    return 'Enter the code sent to $email';
  }

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get sendRecoveryCodeButton => 'Send Recovery Code';

  @override
  String get verifyButton => 'Verify';

  @override
  String get forgotPasswordLink => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get accountCreated => 'Account created! Please sign in.';

  @override
  String get codeVerified => 'Verified Successfully';

  @override
  String get invalidCode => 'Invalid Code';

  @override
  String get codeResent => 'Code resent';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get failedToSendLink => 'Failed to send reset link';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get getStarted => 'Get Started';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get state => 'State';

  @override
  String get localGovernment => 'Local Government';

  @override
  String get village => 'Town/Village';

  @override
  String get ward => 'Ward';

  @override
  String get farmerRegistration => 'Farmer Registration';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get farmInformation => 'Farm Information';

  @override
  String get farmSize => 'Farm Size';

  @override
  String get farmLocation => 'Farm Location';

  @override
  String get cropType => 'Crop Type';

  @override
  String get cropVariety => 'Crop Variety';

  @override
  String get plantingDate => 'Planting Date';

  @override
  String get harvestDate => 'Harvest Date';

  @override
  String get expectedYield => 'Expected Yield';

  @override
  String get farmerId => 'Farmer ID';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get backButton => 'Back';

  @override
  String get finish => 'Finish';

  @override
  String get skip => 'Skip';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get networkError => 'Network error. Please check your connection';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again';

  @override
  String get applicationForm => 'Application Form';

  @override
  String get selectWarehouse => 'Select Warehouse';

  @override
  String get searchWarehouses => 'Search warehouses...';

  @override
  String get noWarehousesFound => 'No warehouses found';

  @override
  String get warehouseSelectionSubtitle =>
      'Please choose a warehouse where your application will be processed';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get search => 'Search';

  @override
  String get theme => 'Theme';

  @override
  String get termsAndConditions => 'Memorandum of Agreement';

  @override
  String get license => 'License';

  @override
  String get viewTerms => 'View Terms & Conditions';

  @override
  String get viewLicense => 'View License';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get logoutConfirmationTitle => 'Log Out';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to log out?';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get bankName => 'Bank Name';

  @override
  String get accountName => 'Account Name';

  @override
  String get farmDetailsAndLocation => 'Farm Details & Location';

  @override
  String get farmSizeCoordinates => 'Farm Size & Coordinates';

  @override
  String get farmSizeHectares => 'Farm Size (Hectares)';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get getCurrentLocation => 'Get Current Location';

  @override
  String get nextOfKin => 'Next of Kin';

  @override
  String get relationship => 'Relationship';

  @override
  String get attestation => 'Attestation';

  @override
  String get attestationStatement =>
      'I hereby certify that the information given in this form is correct and true to the best of my knowledge.';

  @override
  String get iAgree => 'I Agree';

  @override
  String get signature => 'Signature';

  @override
  String get clear => 'Clear';

  @override
  String get saveSignature => 'Save Signature';

  @override
  String get signatureSaved => 'Signature saved!';

  @override
  String get otherNames => 'Other Names';

  @override
  String get passportPhoto => 'Passport Photo';

  @override
  String get kycInformation => 'KYC Information';

  @override
  String get idType => 'ID Type';

  @override
  String get idNumber => 'ID Number';

  @override
  String get nin => 'NIN';

  @override
  String get bvn => 'BVN';

  @override
  String get internationalPassport => 'Passport';

  @override
  String get votersCard => 'Voters Card';

  @override
  String get farmSizeAndCoordinates => 'Farm Size & Coordinates';

  @override
  String get farmDescription => 'Farm Location / Description';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get imageSelected => 'Image Selected';

  @override
  String get applicationSubmitted => 'Application Submitted!';

  @override
  String get applicationSubmittedUnderReview =>
      'Your application has been successfully submitted and is under review.';

  @override
  String get viewApplication => 'View Application';

  @override
  String get confirmSubmit => 'Confirm & Submit';

  @override
  String get signingPassport => 'Uploading signature, passport, and ID card...';

  @override
  String get submittingApplication => 'Submitting form...';

  @override
  String applicationMessageInitial(String name) {
    return 'Dear $name, your application has been submitted and will be in review shortly. You will be notified once the review is completed. You can check the status of your application at any time by logging into your account. You can modify your application before it is reviewed.';
  }

  @override
  String applicationMessageInReview(String name) {
    return 'Dear $name, your application is currently under review by our agents. We will notify you once the process is complete.';
  }

  @override
  String applicationMessageApproved(String name) {
    return 'Congratulations $name! Your application has been approved. You can now proceed with the next steps of the project.';
  }

  @override
  String applicationMessageRejected(String name) {
    return 'Dear $name, we regret to inform you that your application has been rejected at this time. Please check your email or contact support for more details.';
  }

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get faqCheckOut =>
      'Check out our Frequently Asked Questions (FAQ) if you have any concerns:';

  @override
  String get faqQuestion1 => 'How long does the review process take?';

  @override
  String get faqAnswer1 =>
      'Typically, the review process takes between 3 to 5 business days. You will receive a notification once a decision is made.';

  @override
  String get faqQuestion2 => 'Can I edit my application after submission?';

  @override
  String get faqAnswer2 =>
      'Yes, you can edit your application as long as it is still in the \'Initial\' status. Once it moves to \'In Review\', editing will be disabled.';

  @override
  String get faqQuestion3 => 'What documents are required for KYC?';

  @override
  String get faqAnswer3 =>
      'We accept National ID (NIN), BVN, International Passport, or a valid Voters Card for the KYC process.';

  @override
  String get proofOfPaymentRequired =>
      'Upload proof of payment to proceed with application';

  @override
  String get uploadProofOfPayment => 'Upload Proof of Payment';

  @override
  String get proofOfPaymentUploaded => 'Proof of payment uploaded successfully';

  @override
  String get allocatedResources => 'Allocated Resources';

  @override
  String get noResourcesAllocated =>
      'No resources have been allocated to you yet.';

  @override
  String get collected => 'Collected';

  @override
  String get pending => 'Pending';

  @override
  String get collectionAddress => 'Collection Address';

  @override
  String get viewAllocatedResources => 'View Allocated Resources';

  @override
  String get applicationApprovedSuccess =>
      'Great news! Your application has been approved. You can now view and collect your allocated resources below.';

  @override
  String get assignedWarehouse => 'Assigned Warehouse';

  @override
  String get viewAssignedWarehouse => 'View Assigned Warehouse';

  @override
  String get noWarehouseAssigned => 'No warehouse assigned yet.';

  @override
  String get warehouseAssignmentInstruction =>
      'Admins will assign a warehouse during the receiving process.';

  @override
  String get warehouseInformation => 'Warehouse Information';

  @override
  String get instruction => 'Instruction';

  @override
  String get warehouseProceedInstruction =>
      'Please proceed to this warehouse with your produce for submission. Ensure you have your application ID ready.';

  @override
  String get warehouseBagRecordInstruction =>
      'Record the number of bags received with the admin upon submission.';

  @override
  String get selectAgent => 'Select Agent';

  @override
  String get agentSelectionSubtitle =>
      'Please select the agent you are registering under';

  @override
  String get searchAgents => 'Search agents...';

  @override
  String get noAgentsFound => 'No agents found';

  @override
  String get idCard => 'ID Card Photo';

  @override
  String get idCardUploaded => 'ID Card Photo Selected';

  @override
  String get termsAndConditionsContent =>
      'MEMORANDUM OF AGREEMENT\nLABAR GRAINS & FEEDS MERCHANT COMPANY LIMITED\nAND\nFARMERS (OUTGROWER) OF\n2024 WET SEASON PRIVATE ANCHOR BORROWER PROGRAM\n\n1. That the company agrees with the farmer(s) to provide farm inputs: Fertilizer, Agro-chemical, seed & Chicken manure at an agreed price stipulated in the Economic of Production attached.\n\n2. The company and the farmer agree that the farmer(s) shall use all the above farm inputs Provided, for the same variety of seeds will be returned during harvest.\n\n3. The farmer(s) agrees with the Company to pay for the agreed value of inputs provided with maize equivalent at the end of the farming season (on or before 15th November, 2024) even though the off-take price will be determined by the average market price of the neighboring markets on the 15th November 2024.\n\n4. The Company and the Farmer(s) agree that the Company\'s agent must be present on the day of harvest and shall be informed three days prior to the harvest and shall not harvest his farm prematurely for any reason without the approval of the Company.\n\n5. The Farmer(s) agrees with the Company NOT to take his harvest home until he/she has settled and delivered fully the loan package to the location as would be fixed by the Company in due time.\n\n6. The Farmer(s) agrees with the Company to pay the entire loan obligation with maize equivalent as agreed within 1/11/2024 to 30/11/2024. In the event of failure to settle the loan as at when due, the Company shall where the farmer has not made harvest, take over the farm and harvest the equivalent of the total loan package together with the accrued expenses.\n\n7. The Farmer(s) agrees with the Company to pay the sum of N300.00 penalty per hectare for each day of default, starting from the 1/12/2024 until the loan package is fully set-off.\n\n8. The Farmer(s) agrees with the company to register any of the farmer\'s asset with the Company be it moveable or immovable as collateral to the loan, which shall be liquidated where he defaults in paying the loan package on the 30/11/2024.';

  @override
  String get iAgreeToTermsAndAttestation =>
      'I agree to the Attestation and Memorandum of Agreement';
}
