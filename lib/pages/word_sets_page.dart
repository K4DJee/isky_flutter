import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/word_set_page.dart';

class WordSetsPage extends StatefulWidget{
  final int selectedFolderId;
  const WordSetsPage({super.key, required this.selectedFolderId});

  @override
  State<WordSetsPage> createState() => _WordSetsPageState();
}

class _WordSetsPageState extends State<WordSetsPage>{
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listOfSets = [
    {
      "id": 1,
      "name": AppLocalizations.of(context)!.educationSetName,//education
      "path": "./assets/sets/education_en.json",
      "langCode": {
        "en": "./assets/sets/education_en.json",
        "ru": "./assets/sets/education_ru.json",
      },
      "description": AppLocalizations.of(context)!.educationSetDescription
    },
    {
      "id": 2,
      "name": AppLocalizations.of(context)!.foodSetName,//food
      "path": "./assets/sets/food_en.json",
      "langCode": {
        "en": "./assets/sets/food_en.json",
        "ru": "./assets/sets/food_ru.json",
      },
      "description": AppLocalizations.of(context)!.foodSetDescription
    },
    {
      "id": 3,
      "name": AppLocalizations.of(context)!.animalsSetName,//animals
      "path": "./assets/sets/animals_en.json",
      "langCode": {
        "en": "./assets/sets/animals_en.json",
        "ru": "./assets/sets/animals_ru.json",
      },
      "description": AppLocalizations.of(context)!.animalsSetDescription
    },
    {
      "id": 4,
      "name": AppLocalizations.of(context)!.numbersSetName,//numbers
      "path": "./assets/sets/numbers_en.json",
      "langCode": {
        "en": "./assets/sets/numbers_en.json",
        "ru": "./assets/sets/numbers_ru.json",
      },
      "description": AppLocalizations.of(context)!.numbersSetDescription
    },
  ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wordSetsPage),
      ),
      body: Padding(padding: EdgeInsets.all(16),
        child: ListView.builder(
            itemCount: listOfSets.length,
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                title: Text(listOfSets[index]['name'], style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
                subtitle: Text(listOfSets[index]['description'], style: TextStyle(
                  fontSize: 16
                ),),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> WordSetPage(
                    appBarTitle: listOfSets[index]['name'],
                    dataSet: listOfSets[index],
                    selectedFolderId: widget.selectedFolderId,
                  )));
                },
              );
            },
          ),),
    );
  }
  
}