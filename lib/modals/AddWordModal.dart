import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isky_new/l10n/app_localizations.dart';

class AddWordModal extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;
  final List<Map<String, dynamic>> folders;
  final Function(int?)? onFolderSelected; 
  final int? selectedFolderId; 
  final VoidCallback? onCreate;
  const AddWordModal({super.key,
  required this.controller1,
  required this.controller2,
  required this.controller3,
  this.onCreate,
  required this.folders,
  this.onFolderSelected,
  this.selectedFolderId,
  });
  
  void _submit(BuildContext context) {
    print('Попытка отправки формы в модальном окне');
    String word = controller1.text.trim();
    String translate = controller2.text.trim();
    String example = controller3.text.trim();
    if (word.isNotEmpty && translate.isNotEmpty && selectedFolderId != null) {
      print('Добавленное слово: $word, его перевод $translate, папка ID: $selectedFolderId');
      Navigator.pop(context);
      if (onCreate != null) {
        print('Вызов onCreate...');
        onCreate!();
      } else {
        print('onCreate не определён');
      }
    } else {
      print('Ошибка добавления слова: word, translate или folderId пустые');
      print('word: $word, translate: $translate, example: $example, selectedFolderId: $selectedFolderId');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.addWordModal, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            const SizedBox(height: 20),
            TextField(
              controller: controller1,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.wordInput,
                border:OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.wordHint
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller2,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translateInput,
                border:OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.translateHint
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller3,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.exampleInput,
                border:OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.exampleHint
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton(
              hint:  Text(AppLocalizations.of(context)!.selectFolder),
              value: selectedFolderId,
              items: folders.map((folder){
                return DropdownMenuItem<int>(
                  value: folder['id'] as int,
                  child: Text(folder['name'] as String),
                );
              }).toList(),
              isExpanded: true,
              style: TextStyle(),
            
               onChanged: (int? newValue){
                if(onFolderSelected != null && newValue != null){
                  onFolderSelected!(newValue);
                }
               }
               ),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => _submit(context),
                  child:  Text(AppLocalizations.of(context)!.addWordButton),
                ),
              ),
              const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => Navigator.pop(context),
                  child:  Text(AppLocalizations.of(context)!.closeButton),
                ),
              ),
            ]),
      ),
    );
  }
}
