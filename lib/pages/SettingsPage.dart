//Settings Page
import 'package:flutter/material.dart';
import 'package:isky_new/helpers/themes.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/models/languages.dart';
import 'package:isky_new/pages/foldersActions.dart';
import 'package:isky_new/pages/testPage.dart';
import 'package:provider/provider.dart';
import 'package:isky_new/providers/locale_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
    bool light = false;
    Languages? _selectedLanguageItem;
    late String _selectedCodeLanguage;
    static final List<Languages> _languages = [
      Languages(lang: 'English', code: 'en'),
      Languages(lang: 'Русский', code: 'ru'),
    ];
    
    void _showLanguagePicker(BuildContext context) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.selectLanguage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final lang = _languages[index];
              return ListTile(
                title: Text(lang.lang),
                onTap: () {
                  setState(() {
                    _selectedLanguageItem = lang;
                    _selectedCodeLanguage = lang.code;
                  });
                  localeProvider.setLocale(Locale(lang.code));
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

    @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsPage),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
                const Divider(),
                  SwitchListTile(
                    value: themeProvider.isDark,
                    title:Text(AppLocalizations.of(context)!.bgColor,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500  ),),
                    onChanged: (value){
                    themeProvider.toggleTheme();
                    },
                    activeColor: const Color.fromARGB(255, 77, 183, 58),
                    ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.interfaceAppColor,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.color_lens),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.deletingAFolder,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.delete),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const folderActionsPage()),
                );
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.exportAndImportFoldersInExcel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.folder_copy_rounded),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.removeAds,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.close),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                InkWell(
                  onTap: () {
                    _showLanguagePicker(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              _selectedLanguageItem?.lang ?? AppLocalizations.of(context)!.selectLanguage,
                              style: TextStyle( fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.shareApp, 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.share),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.rateUs,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.reviews),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.feedback, 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.feedback),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text('Тест', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.feedback),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    Navigator.push(context,  MaterialPageRoute(builder: (context)=> TestPage()));
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.privacyPolicy, 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  trailing: Icon(Icons.privacy_tip),
                  selectedTileColor: Colors.black,
                  onTap:(){
                    
                  }
                ),
                ListTile(
                  title:Text(AppLocalizations.of(context)!.appVersion, 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                )
        ],
      ),
    );
    
  }
  }