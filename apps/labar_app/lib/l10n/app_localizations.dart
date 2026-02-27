import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ha.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ha')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Labar Grains'**
  String get appName;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Reset password button text
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your dashboard'**
  String get signInSubtitle;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and start your journey'**
  String get signUpSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a recovery code'**
  String get forgotPasswordSubtitle;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCodeTitle;

  /// No description provided for @verifyCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {email}'**
  String verifyCodeSubtitle(String email);

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @sendRecoveryCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send Recovery Code'**
  String get sendRecoveryCodeButton;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLink;

  /// Don't have account prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Already have account prompt
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// Password too short validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please sign in.'**
  String get accountCreated;

  /// No description provided for @codeVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified Successfully'**
  String get codeVerified;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Code'**
  String get invalidCode;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent'**
  String get codeResent;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @failedToSendLink.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link'**
  String get failedToSendLink;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Local government field label
  ///
  /// In en, this message translates to:
  /// **'Local Government'**
  String get localGovernment;

  /// Village field label
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// Ward field label
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get ward;

  /// Farmer registration title
  ///
  /// In en, this message translates to:
  /// **'Farmer Registration'**
  String get farmerRegistration;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Contact information section title
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Farm information section title
  ///
  /// In en, this message translates to:
  /// **'Farm Information'**
  String get farmInformation;

  /// Farm size field label
  ///
  /// In en, this message translates to:
  /// **'Farm Size'**
  String get farmSize;

  /// Farm location field label
  ///
  /// In en, this message translates to:
  /// **'Farm Location'**
  String get farmLocation;

  /// Crop type field label
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get cropType;

  /// Crop variety field label
  ///
  /// In en, this message translates to:
  /// **'Crop Variety'**
  String get cropVariety;

  /// Planting date field label
  ///
  /// In en, this message translates to:
  /// **'Planting Date'**
  String get plantingDate;

  /// Harvest date field label
  ///
  /// In en, this message translates to:
  /// **'Harvest Date'**
  String get harvestDate;

  /// Expected yield field label
  ///
  /// In en, this message translates to:
  /// **'Expected Yield'**
  String get expectedYield;

  /// Farmer ID field label
  ///
  /// In en, this message translates to:
  /// **'Farmer ID'**
  String get farmerId;

  /// Date of birth field label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Gender field label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Back button tooltip
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// Finish button text
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Passwords don't match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Invalid phone number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneNumber;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection'**
  String get networkError;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again'**
  String get somethingWentWrong;

  /// Application form title
  ///
  /// In en, this message translates to:
  /// **'Application Form'**
  String get applicationForm;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Notifications label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Theme settings label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Terms and Conditions label
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// License label
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// View Terms & Conditions button text
  ///
  /// In en, this message translates to:
  /// **'View Terms & Conditions'**
  String get viewTerms;

  /// View License button text
  ///
  /// In en, this message translates to:
  /// **'View License'**
  String get viewLicense;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutConfirmationTitle;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationMessage;

  /// Bank details section title
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// Account number field label
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// Bank name field label
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// Account name field label
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// Farm details and location section title
  ///
  /// In en, this message translates to:
  /// **'Farm Details & Location'**
  String get farmDetailsAndLocation;

  /// Farm size and coordinates subsection title
  ///
  /// In en, this message translates to:
  /// **'Farm Size & Coordinates'**
  String get farmSizeCoordinates;

  /// Farm size in hectares label
  ///
  /// In en, this message translates to:
  /// **'Farm Size (Hectares)'**
  String get farmSizeHectares;

  /// Latitude label
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// Longitude label
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// Get current location button text
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;

  /// Next of kin section title
  ///
  /// In en, this message translates to:
  /// **'Next of Kin'**
  String get nextOfKin;

  /// Relationship field label
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// Attestation section title
  ///
  /// In en, this message translates to:
  /// **'Attestation'**
  String get attestation;

  /// Attestation statement text
  ///
  /// In en, this message translates to:
  /// **'I hereby certify that the information given in this form is correct and true to the best of my knowledge.'**
  String get attestationStatement;

  /// I agree checkbox label
  ///
  /// In en, this message translates to:
  /// **'I Agree'**
  String get iAgree;

  /// Signature section title
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Save signature button text
  ///
  /// In en, this message translates to:
  /// **'Save Signature'**
  String get saveSignature;

  /// Signature saved success message
  ///
  /// In en, this message translates to:
  /// **'Signature saved!'**
  String get signatureSaved;

  /// Other names field label
  ///
  /// In en, this message translates to:
  /// **'Other Names'**
  String get otherNames;

  /// Passport photo field label
  ///
  /// In en, this message translates to:
  /// **'Passport Photo'**
  String get passportPhoto;

  /// KYC information section title
  ///
  /// In en, this message translates to:
  /// **'KYC Information'**
  String get kycInformation;

  /// ID Type label
  ///
  /// In en, this message translates to:
  /// **'ID Type'**
  String get idType;

  /// ID Number label
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// National Identification Number option
  ///
  /// In en, this message translates to:
  /// **'NIN'**
  String get nin;

  /// Bank Verification Number option
  ///
  /// In en, this message translates to:
  /// **'BVN'**
  String get bvn;

  /// International Passport option
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get internationalPassport;

  /// Voters Card option
  ///
  /// In en, this message translates to:
  /// **'Voters Card'**
  String get votersCard;

  /// Title for farm size and coordinates subsection
  ///
  /// In en, this message translates to:
  /// **'Farm Size & Coordinates'**
  String get farmSizeAndCoordinates;

  /// Farm location description label
  ///
  /// In en, this message translates to:
  /// **'Farm Location / Description'**
  String get farmDescription;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @imageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image Selected'**
  String get imageSelected;

  /// Title for the application submitted success screen
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get applicationSubmitted;

  /// Subtitle for the application submitted success screen
  ///
  /// In en, this message translates to:
  /// **'Your application has been successfully submitted and is under review.'**
  String get applicationSubmittedUnderReview;

  /// Button text to view the submitted application
  ///
  /// In en, this message translates to:
  /// **'View Application'**
  String get viewApplication;

  /// Button text to confirm and submit the application
  ///
  /// In en, this message translates to:
  /// **'Confirm & Submit'**
  String get confirmSubmit;

  /// Loading message when uploading biometrics
  ///
  /// In en, this message translates to:
  /// **'Uploading signature and passport...'**
  String get signingPassport;

  /// Loading message when submitting the application form
  ///
  /// In en, this message translates to:
  /// **'Submitting form...'**
  String get submittingApplication;

  /// No description provided for @applicationMessageInitial.
  ///
  /// In en, this message translates to:
  /// **'Dear {name}, your application has been submitted and will be in review shortly. You will be notified once the review is completed. You can check the status of your application at any time by logging into your account. You can modify your application before it is reviewed.'**
  String applicationMessageInitial(String name);

  /// No description provided for @applicationMessageInReview.
  ///
  /// In en, this message translates to:
  /// **'Dear {name}, your application is currently under review by our agents. We will notify you once the process is complete.'**
  String applicationMessageInReview(String name);

  /// No description provided for @applicationMessageApproved.
  ///
  /// In en, this message translates to:
  /// **'Congratulations {name}! Your application has been approved. You can now proceed with the next steps of the project.'**
  String applicationMessageApproved(String name);

  /// No description provided for @applicationMessageRejected.
  ///
  /// In en, this message translates to:
  /// **'Dear {name}, we regret to inform you that your application has been rejected at this time. Please check your email or contact support for more details.'**
  String applicationMessageRejected(String name);

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @faqCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check out our Frequently Asked Questions (FAQ) if you have any concerns:'**
  String get faqCheckOut;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How long does the review process take?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'Typically, the review process takes between 3 to 5 business days. You will receive a notification once a decision is made.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Can I edit my application after submission?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can edit your application as long as it is still in the \'Initial\' status. Once it moves to \'In Review\', editing will be disabled.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'What documents are required for KYC?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'We accept National ID (NIN), BVN, International Passport, or a valid Voters Card for the KYC process.'**
  String get faqAnswer3;

  /// No description provided for @proofOfPaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Upload proof of payment to proceed with application'**
  String get proofOfPaymentRequired;

  /// No description provided for @uploadProofOfPayment.
  ///
  /// In en, this message translates to:
  /// **'Upload Proof of Payment'**
  String get uploadProofOfPayment;

  /// No description provided for @proofOfPaymentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Proof of payment uploaded successfully'**
  String get proofOfPaymentUploaded;

  /// No description provided for @allocatedResources.
  ///
  /// In en, this message translates to:
  /// **'Allocated Resources'**
  String get allocatedResources;

  /// No description provided for @noResourcesAllocated.
  ///
  /// In en, this message translates to:
  /// **'No resources have been allocated to you yet.'**
  String get noResourcesAllocated;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @collectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Collection Address'**
  String get collectionAddress;

  /// No description provided for @viewAllocatedResources.
  ///
  /// In en, this message translates to:
  /// **'View Allocated Resources'**
  String get viewAllocatedResources;

  /// No description provided for @applicationApprovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Great news! Your application has been approved. You can now view and collect your allocated resources below.'**
  String get applicationApprovedSuccess;

  /// No description provided for @assignedWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Assigned Warehouse'**
  String get assignedWarehouse;

  /// No description provided for @viewAssignedWarehouse.
  ///
  /// In en, this message translates to:
  /// **'View Assigned Warehouse'**
  String get viewAssignedWarehouse;

  /// No description provided for @noWarehouseAssigned.
  ///
  /// In en, this message translates to:
  /// **'No warehouse assigned yet.'**
  String get noWarehouseAssigned;

  /// No description provided for @warehouseAssignmentInstruction.
  ///
  /// In en, this message translates to:
  /// **'Admins will assign a warehouse during the receiving process.'**
  String get warehouseAssignmentInstruction;

  /// No description provided for @warehouseInformation.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Information'**
  String get warehouseInformation;

  /// No description provided for @instruction.
  ///
  /// In en, this message translates to:
  /// **'Instruction'**
  String get instruction;

  /// No description provided for @warehouseProceedInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please proceed to this warehouse with your produce for submission. Ensure you have your application ID ready.'**
  String get warehouseProceedInstruction;

  /// No description provided for @warehouseBagRecordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Record the number of bags received with the admin upon submission.'**
  String get warehouseBagRecordInstruction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ha'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ha':
      return AppLocalizationsHa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
