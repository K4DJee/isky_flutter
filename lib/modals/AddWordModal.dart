import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isky_new/l10n/app_localizations.dart';

class AddWordModal extends StatefulWidget {
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
  
  State<AddWordModal> createState() => _AddWordModalState();

}
  
  class _AddWordModalState extends State<AddWordModal>{
    int? _selectedFolderId;

    @override
  void initState() {
    super.initState();
    _selectedFolderId = widget.selectedFolderId;
  }

    void _submit(BuildContext context) {
    print('Попытка отправки формы в модальном окне');
    String word = widget.controller1.text.trim();
    String translate = widget.controller2.text.trim();
    String example = widget.controller3.text.trim();
    if (word.isNotEmpty && translate.isNotEmpty && _selectedFolderId != null) {
      print('Добавленное слово: $word, его перевод $translate, папка ID: $_selectedFolderId');
      Navigator.pop(context);
      if (widget.onCreate != null) {
        print('Вызов onCreate...');
        widget.onCreate!();
      } else {
        print('onCreate не определён');
      }
    } else {
      print('Ошибка добавления слова: word, translate или folderId пустые');
      print('word: $word, translate: $translate, example: $example, selectedFolderId: $_selectedFolderId');
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
              controller: widget.controller1,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.wordInput,
                border:OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.wordHint
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.controller2,
              autofocus: false,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translateInput,
                border:OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.translateHint
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.controller3,
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
              value: _selectedFolderId,
              items: widget.folders.map((folder){
                return DropdownMenuItem<int>(
                  value: folder['id'] as int,
                  child: Text(folder['name'] as String),
                );
              }).toList(),
              isExpanded: true,
              
            
               onChanged: (int? newValue){
                setState(() {
                    _selectedFolderId = newValue;
                  });
                  if (widget.onFolderSelected != null) {
                    widget.onFolderSelected!(newValue);
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

  

