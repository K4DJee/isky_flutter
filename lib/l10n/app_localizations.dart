import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Isky'**
  String get appTitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @yourFolders.
  ///
  /// In en, this message translates to:
  /// **'Your folders'**
  String get yourFolders;

  /// No description provided for @mainPage.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainPage;

  /// No description provided for @synchronizationPage.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get synchronizationPage;

  /// No description provided for @statisticsPage.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsPage;

  /// No description provided for @educationAnki.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get educationAnki;

  /// No description provided for @settingsPage.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPage;

  /// No description provided for @showBottomSheetChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get showBottomSheetChange;

  /// No description provided for @addFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get addFolderTooltip;

  /// No description provided for @addWordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWordTooltip;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @addWordButton.
  ///
  /// In en, this message translates to:
  /// **'Add word'**
  String get addWordButton;

  /// No description provided for @addWordModal.
  ///
  /// In en, this message translates to:
  /// **'Adding a word'**
  String get addWordModal;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get deleteConfirmation;

  /// No description provided for @wordInput.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get wordInput;

  /// No description provided for @translateInput.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateInput;

  /// No description provided for @exampleInput.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get exampleInput;

  /// No description provided for @createNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Creating new folder'**
  String get createNewFolder;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select folder'**
  String get selectFolder;

  /// No description provided for @nameFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get nameFolder;

  /// No description provided for @createFolderButton.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get createFolderButton;

  /// No description provided for @folderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the folder name'**
  String get folderNameHint;

  /// No description provided for @wordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the word'**
  String get wordHint;

  /// No description provided for @translateHint.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateHint;

  /// No description provided for @exampleHint.
  ///
  /// In en, this message translates to:
  /// **'Example (optional)'**
  String get exampleHint;

  /// No description provided for @wordsInFolder.
  ///
  /// In en, this message translates to:
  /// **'Words: '**
  String get wordsInFolder;

  /// No description provided for @selectedFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder:'**
  String get selectedFolderTitle;

  /// No description provided for @folderAbsent.
  ///
  /// In en, this message translates to:
  /// **'no folder'**
  String get folderAbsent;

  /// No description provided for @wordActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a word'**
  String get wordActionsTitle;

  /// No description provided for @localSync.
  ///
  /// In en, this message translates to:
  /// **'Local synchronization'**
  String get localSync;

  /// No description provided for @globalSync.
  ///
  /// In en, this message translates to:
  /// **'Global synchronization'**
  String get globalSync;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyHeader.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy of the Isky Application'**
  String get privacyPolicyHeader;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: October 23, 2025'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @privacyPolicyWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the privacy policy of the Isky application (\"Application\"). This policy describes how we collect, use, store, and protect your personal information when using the Application. The Isky application is developed by K4DJE Studio (developer: K4DJE, Dmitry Mishchenko) and is available on MacOS, Linux, Windows, Android, and iOS platforms. We strive for maximum transparency and protection of your privacy.'**
  String get privacyPolicyWelcome;

  /// No description provided for @privacyPolicyAgreement.
  ///
  /// In en, this message translates to:
  /// **'By using the Application, you agree to the terms of this policy. If you do not agree, please do not use the Application.'**
  String get privacyPolicyAgreement;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection1Description.
  ///
  /// In en, this message translates to:
  /// **'The Isky application is designed for creating dictionaries, organizing words into folders, exporting and importing data via JSON files, as well as synchronizing data between devices. We minimize the collection of personal data and do not store it on our servers unless necessary.'**
  String get privacyPolicySection1Description;

  /// No description provided for @privacyPolicySection1_1Title.
  ///
  /// In en, this message translates to:
  /// **'1.1. User-Provided Data'**
  String get privacyPolicySection1_1Title;

  /// No description provided for @privacyPolicySection1_1DictionaryContent.
  ///
  /// In en, this message translates to:
  /// **'- Dictionary Content: Words, folders, and related data that you enter into the Application. This data is stored locally on your device.'**
  String get privacyPolicySection1_1DictionaryContent;

  /// No description provided for @privacyPolicySection1_1SyncData.
  ///
  /// In en, this message translates to:
  /// **'- Sync Data: During local synchronization (via Wi-Fi on the same network) or global synchronization (via a intermediary server), only your dictionary data is transmitted. The server does not store this data; it acts solely as a temporary intermediary for transmission between devices.'**
  String get privacyPolicySection1_1SyncData;

  /// No description provided for @privacyPolicySection1_2Title.
  ///
  /// In en, this message translates to:
  /// **'1.2. Automatically Collected Data'**
  String get privacyPolicySection1_2Title;

  /// No description provided for @privacyPolicySection1_2TechnicalInfo.
  ///
  /// In en, this message translates to:
  /// **'- Technical Information: IP address, device type, OS version, unique device identifier (for synchronization and debugging errors).'**
  String get privacyPolicySection1_2TechnicalInfo;

  /// No description provided for @privacyPolicySection1_2UsageData.
  ///
  /// In en, this message translates to:
  /// **'- Usage Data: Information about interactions with the Application, such as frequency of feature usage, for product improvement (anonymized).'**
  String get privacyPolicySection1_2UsageData;

  /// No description provided for @privacyPolicySection1_2AdData.
  ///
  /// In en, this message translates to:
  /// **'- Advertising Data: The Application integrates ads via Yandex Ads. Yandex may collect data for ad personalization, including device identifiers, approximate location (based on IP), and behavior in the Application. We do not have access to this data; it is processed by Yandex in accordance with their privacy policy.'**
  String get privacyPolicySection1_2AdData;

  /// No description provided for @privacyPolicyNoSensitiveData.
  ///
  /// In en, this message translates to:
  /// **'We do not collect sensitive information such as biometric data, financial information, or health data.'**
  String get privacyPolicyNoSensitiveData;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection2Services.
  ///
  /// In en, this message translates to:
  /// **'- For Providing Services: Storing and synchronizing your dictionary data between devices.'**
  String get privacyPolicySection2Services;

  /// No description provided for @privacyPolicySection2Improvement.
  ///
  /// In en, this message translates to:
  /// **'- For Improving the Application: Analyzing anonymized usage data to identify errors and optimize features.'**
  String get privacyPolicySection2Improvement;

  /// No description provided for @privacyPolicySection2Ads.
  ///
  /// In en, this message translates to:
  /// **'- For Advertising: Yandex Ads uses collected data to display relevant ads. We do not participate in this process directly.'**
  String get privacyPolicySection2Ads;

  /// No description provided for @privacyPolicySection2Legal.
  ///
  /// In en, this message translates to:
  /// **'- For Legal Compliance: If necessary, to fulfill legal obligations, such as responding to requests from authorities.'**
  String get privacyPolicySection2Legal;

  /// No description provided for @privacyPolicyNoSellingData.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information to third parties.'**
  String get privacyPolicyNoSellingData;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Disclosure of Information to Third Parties'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection3YandexAds.
  ///
  /// In en, this message translates to:
  /// **'- Yandex Ads: For ad integration, we share minimal technical data (e.g., device identifiers) with Yandex. Details of Yandex data processing are available in their privacy policy[](https://yandex.com/legal/confidential/).'**
  String get privacyPolicySection3YandexAds;

  /// No description provided for @privacyPolicySection3SyncServers.
  ///
  /// In en, this message translates to:
  /// **'- Sync Servers: During global synchronization, data is transmitted through our servers but not stored on them. We may use cloud providers (e.g., AWS or similar) for hosting, which are committed to security standards.'**
  String get privacyPolicySection3SyncServers;

  /// No description provided for @privacyPolicySection3OtherCases.
  ///
  /// In en, this message translates to:
  /// **'- Other Cases: We may disclose information if required by law, to protect our rights, or in the event of a merger/acquisition of K4DJE Studio.'**
  String get privacyPolicySection3OtherCases;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Data Storage and Security'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection4LocalStorage.
  ///
  /// In en, this message translates to:
  /// **'- Local Storage: Most data is stored on your device. We recommend using passwords and device encryption for protection.'**
  String get privacyPolicySection4LocalStorage;

  /// No description provided for @privacyPolicySection4Sync.
  ///
  /// In en, this message translates to:
  /// **'- Synchronization: Data is transmitted in encrypted form (using HTTPS). The server does not store data after transmission.'**
  String get privacyPolicySection4Sync;

  /// No description provided for @privacyPolicySection4Retention.
  ///
  /// In en, this message translates to:
  /// **'- Retention Period: We do not store your data on servers. Local data is deleted upon uninstallation of the Application or at your request.'**
  String get privacyPolicySection4Retention;

  /// No description provided for @privacyPolicySection4Security.
  ///
  /// In en, this message translates to:
  /// **'- Security Measures: We apply standard measures such as encryption, firewalls, and regular audits to protect against unauthorized access. However, no system is completely secure, and we cannot guarantee absolute protection.'**
  String get privacyPolicySection4Security;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicySection5RightsIntro.
  ///
  /// In en, this message translates to:
  /// **'Depending on your location (e.g., in accordance with GDPR in the EU or the Russian Federal Law \"On Personal Data\"), you have rights:'**
  String get privacyPolicySection5RightsIntro;

  /// No description provided for @privacyPolicySection5Access.
  ///
  /// In en, this message translates to:
  /// **'- Access to your data.'**
  String get privacyPolicySection5Access;

  /// No description provided for @privacyPolicySection5Correction.
  ///
  /// In en, this message translates to:
  /// **'- Correction or update of data.'**
  String get privacyPolicySection5Correction;

  /// No description provided for @privacyPolicySection5Deletion.
  ///
  /// In en, this message translates to:
  /// **'- Deletion of data (e.g., via export and cleanup in the Application).'**
  String get privacyPolicySection5Deletion;

  /// No description provided for @privacyPolicySection5OptOut.
  ///
  /// In en, this message translates to:
  /// **'- Opt-out from processing (including disabling ads if possible).'**
  String get privacyPolicySection5OptOut;

  /// No description provided for @privacyPolicySection5Complaint.
  ///
  /// In en, this message translates to:
  /// **'- Complaint to a supervisory authority.'**
  String get privacyPolicySection5Complaint;

  /// No description provided for @privacyPolicySection5Contact.
  ///
  /// In en, this message translates to:
  /// **'To exercise these rights, contact us at the details below.'**
  String get privacyPolicySection5Contact;

  /// No description provided for @privacyPolicySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Children\'s Data'**
  String get privacyPolicySection6Title;

  /// No description provided for @privacyPolicySection6Children.
  ///
  /// In en, this message translates to:
  /// **'The Application is not intended for children under 13 years old (or equivalent age under local law). We do not knowingly collect data from children. If you are a parent and believe your child has provided us with data, contact us for deletion.'**
  String get privacyPolicySection6Children;

  /// No description provided for @privacyPolicySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Changes to the Policy'**
  String get privacyPolicySection7Title;

  /// No description provided for @privacyPolicySection7Changes.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy. Changes will be published in the Application or on our website. Continued use of the Application after updates means agreement with the changes.'**
  String get privacyPolicySection7Changes;

  /// No description provided for @privacyPolicySection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Contacts'**
  String get privacyPolicySection8Title;

  /// No description provided for @privacyPolicySection8Questions.
  ///
  /// In en, this message translates to:
  /// **'If you have questions or requests, contact us:'**
  String get privacyPolicySection8Questions;

  /// No description provided for @privacyPolicySection8Developer.
  ///
  /// In en, this message translates to:
  /// **'- Developer: Dmitry Mishchenko (K4DJE)'**
  String get privacyPolicySection8Developer;

  /// No description provided for @privacyPolicySection8Email.
  ///
  /// In en, this message translates to:
  /// **'- Email: k4djexfullstack@gmail.com'**
  String get privacyPolicySection8Email;

  /// No description provided for @privacyPolicySection8Studio.
  ///
  /// In en, this message translates to:
  /// **'- Studio: K4DJE Studio'**
  String get privacyPolicySection8Studio;

  /// No description provided for @privacyPolicyThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Isky! We appreciate your trust.'**
  String get privacyPolicyThanks;

  /// No description provided for @stillInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Still in development'**
  String get stillInDevelopment;

  /// No description provided for @incompletePage.
  ///
  /// In en, this message translates to:
  /// **'Incomplete page'**
  String get incompletePage;

  /// No description provided for @skipBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipBtn;

  /// No description provided for @onboardingSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'Transfer data over WI-FI or save it in a JSON file.'**
  String get onboardingSubtitle5;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Share your dictionary without the Internet'**
  String get onboardingTitle5;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'With the help of data statistics, you can see your growth'**
  String get onboardingSubtitle4;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your progress'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Flashcards and other mini games will help you memorize foreign words.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Learn words by playing'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Group words by topic, level, or language, whichever suits you best.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Create folders and add words'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'This application specializes in improving the learning process of foreign language words.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Isky app'**
  String get onboardingTitle1;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorTitle;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when importing data'**
  String get importError;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'Data import has been canceled'**
  String get importCanceled;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data import completed'**
  String get importSuccess;

  /// No description provided for @importLoad.
  ///
  /// In en, this message translates to:
  /// **'Data is being imported'**
  String get importLoad;

  /// No description provided for @selectFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a file'**
  String get selectFileTitle;

  /// No description provided for @selectFileForImport.
  ///
  /// In en, this message translates to:
  /// **'Select the file with the extension .the json you want to import:'**
  String get selectFileForImport;

  /// No description provided for @filePathAfterEport.
  ///
  /// In en, this message translates to:
  /// **'The file was saved along the way:'**
  String get filePathAfterEport;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred when exporting data'**
  String get exportError;

  /// No description provided for @exportCanceled.
  ///
  /// In en, this message translates to:
  /// **'Data export has been canceled.'**
  String get exportCanceled;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data export completed'**
  String get exportSuccess;

  /// No description provided for @exportLoad.
  ///
  /// In en, this message translates to:
  /// **'The data is being exported'**
  String get exportLoad;

  /// No description provided for @exportAndImportTitle.
  ///
  /// In en, this message translates to:
  /// **'When importing data, all previous data will be permanently deleted.'**
  String get exportAndImportTitle;

  /// No description provided for @importingDataTile.
  ///
  /// In en, this message translates to:
  /// **'Importing data'**
  String get importingDataTile;

  /// No description provided for @exportingDataTile.
  ///
  /// In en, this message translates to:
  /// **'Exporting data'**
  String get exportingDataTile;

  /// No description provided for @exportAndImportPage.
  ///
  /// In en, this message translates to:
  /// **'Exporting and importing data'**
  String get exportAndImportPage;

  /// No description provided for @receiveData.
  ///
  /// In en, this message translates to:
  /// **'Receive data'**
  String get receiveData;

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select an action:'**
  String get selectAction;

  /// No description provided for @receivingBtn.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get receivingBtn;

  /// No description provided for @sendingBtn.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get sendingBtn;

  /// No description provided for @dataReceiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'The data was successfully received'**
  String get dataReceiveSuccess;

  /// No description provided for @dataReceiveLoad.
  ///
  /// In en, this message translates to:
  /// **'Data is being received'**
  String get dataReceiveLoad;

  /// No description provided for @cancelSend.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelSend;

  /// No description provided for @retrySend.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retrySend;

  /// No description provided for @dataFailedSent.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send data'**
  String get dataFailedSent;

  /// No description provided for @exitBtn.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitBtn;

  /// No description provided for @dataSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'The data has been sent successfully!'**
  String get dataSentSuccessfully;

  /// No description provided for @sendingDataToRecipent.
  ///
  /// In en, this message translates to:
  /// **'Sending data to the recipient'**
  String get sendingDataToRecipent;

  /// No description provided for @sendData.
  ///
  /// In en, this message translates to:
  /// **'Send data'**
  String get sendData;

  /// No description provided for @receiverIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Recipient\'s IP address'**
  String get receiverIpAddress;

  /// No description provided for @qrScanTitle.
  ///
  /// In en, this message translates to:
  /// **'QR scanner is only available on mobile devices'**
  String get qrScanTitle;

  /// No description provided for @scanRecipientQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the recipient\'s QR code'**
  String get scanRecipientQRCode;

  /// No description provided for @sendDataToLocalServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Send data to IP:'**
  String get sendDataToLocalServerTitle;

  /// No description provided for @localServerStatus2.
  ///
  /// In en, this message translates to:
  /// **'The server is enabled'**
  String get localServerStatus2;

  /// No description provided for @localServerStatus1.
  ///
  /// In en, this message translates to:
  /// **'The server is turned off'**
  String get localServerStatus1;

  /// No description provided for @urQRCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your QR code for transmission over IP:'**
  String get urQRCodeTitle;

  /// No description provided for @stopReceivingData.
  ///
  /// In en, this message translates to:
  /// **'Stop receiving data'**
  String get stopReceivingData;

  /// No description provided for @receiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Click \'Receive\' to generate a QR code'**
  String get receiveTitle;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @selectTimeForWorkout.
  ///
  /// In en, this message translates to:
  /// **'Сhoose the time you want to complete the workout'**
  String get selectTimeForWorkout;

  /// No description provided for @timePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Spelling a word based on the translation of time'**
  String get timePageTitle;

  /// No description provided for @wordInFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Word:'**
  String get wordInFlashcard;

  /// No description provided for @translateInFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Translate:'**
  String get translateInFlashcard;

  /// No description provided for @noMoreWords.
  ///
  /// In en, this message translates to:
  /// **'No more words'**
  String get noMoreWords;

  /// No description provided for @highDifficulty.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highDifficulty;

  /// No description provided for @mediumDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumDifficulty;

  /// No description provided for @lowDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get lowDifficulty;

  /// No description provided for @nextWord.
  ///
  /// In en, this message translates to:
  /// **'Next word'**
  String get nextWord;

  /// No description provided for @showAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @totalNumberAnswers.
  ///
  /// In en, this message translates to:
  /// **'Total number of answers: '**
  String get totalNumberAnswers;

  /// No description provided for @numberIncorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'Number of incorrect answers:'**
  String get numberIncorrectAnswers;

  /// No description provided for @numberCorrectAnswers.
  ///
  /// In en, this message translates to:
  /// **'Number of correct answers:'**
  String get numberCorrectAnswers;

  /// No description provided for @averageNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Average number of answers per day:'**
  String get averageNumberTitle;

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'Words learned:'**
  String get wordsLearned;

  /// No description provided for @searchWords.
  ///
  /// In en, this message translates to:
  /// **'Search words'**
  String get searchWords;

  /// No description provided for @noWords.
  ///
  /// In en, this message translates to:
  /// **'There are no words'**
  String get noWords;

  /// No description provided for @noWordsDescription.
  ///
  /// In en, this message translates to:
  /// **'There are no words for the flashcards. Add new words or wait for words.'**
  String get noWordsDescription;

  /// No description provided for @showExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to finish the workout?'**
  String get showExitDialogTitle;

  /// No description provided for @yesAction.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesAction;

  /// No description provided for @noAction.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noAction;

  /// No description provided for @globalSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Word folders are transferred through a server that mediates between the two devices. The server does not store any data, it only resends the database.'**
  String get globalSyncDescription;

  /// No description provided for @localSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'How does local sync work? You can transfer all your folders to another device via a Wi-Fi hotspot or when both devices are connected to the same Wi-Fi network.'**
  String get localSyncDescription;

  /// No description provided for @renameFolder.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameFolder;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFolder;

  /// No description provided for @folderActionsPage.
  ///
  /// In en, this message translates to:
  /// **'Folder management'**
  String get folderActionsPage;

  /// No description provided for @allFlashcards.
  ///
  /// In en, this message translates to:
  /// **'All words'**
  String get allFlashcards;

  /// No description provided for @timePage.
  ///
  /// In en, this message translates to:
  /// **'For a while'**
  String get timePage;

  /// No description provided for @noWordsFound.
  ///
  /// In en, this message translates to:
  /// **'Words not found'**
  String get noWordsFound;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @daysGenitive.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysGenitive;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @deleteWord.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteWord;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @bgColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get bgColor;

  /// No description provided for @interfaceAppColor.
  ///
  /// In en, this message translates to:
  /// **'The color of the app interface'**
  String get interfaceAppColor;

  /// No description provided for @deletingAFolder.
  ///
  /// In en, this message translates to:
  /// **'Deleting a folder'**
  String get deletingAFolder;

  /// No description provided for @exportAndImportFoldersInExcel.
  ///
  /// In en, this message translates to:
  /// **'Export and import folder in Excel'**
  String get exportAndImportFoldersInExcel;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get shareApp;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get rateUs;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.00'**
  String get appVersion;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
