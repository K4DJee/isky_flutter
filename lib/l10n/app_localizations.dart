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
