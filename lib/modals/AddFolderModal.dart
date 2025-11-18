import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/l10n/app_localizations.dart';

class AddFolderModal extends StatelessWidget {
  final TextEditingController controller;
   final VoidCallback? onCreate;
  const AddFolderModal({super.key,
  required this.controller,
  this.onCreate,
  });
  
  void _submit(BuildContext context) {
    // print('Попытка отправки формы в модальном окне');
    String folderName = controller.text.trim();
    String? errorText;
    if (folderName.isNotEmpty) {
      // print('Имя папки: $folderName');
      errorText = null;
      Navigator.pop(context);
      if (onCreate != null) {
        // print('Вызов onCreate...');
        onCreate!();
      } else {
        // print('onCreate не определён');
      }
    } else {
      // print('Имя папки пустое, отправка отменена');
      errorText = AppLocalizations.of(context)!.folderModalError2;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorTitle} ${AppLocalizations.of(context)!.folderModalError1}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    String? errorText;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.createNewFolder,
            style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            const SizedBox(height: 20),
            TextField(
              autofocus: false,
              controller: controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameFolder,
                errorText: errorText,
                border:OutlineInputBorder(),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Красная рамка при ошибке
                ),
                hintText: AppLocalizations.of(context)!.folderNameHint
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
                  onPressed: () => _submit(context),
                  child:  Text(AppLocalizations.of(context)!.createFolderButton),
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
                  child: Text(AppLocalizations.of(context)!.closeButton),
                ),
              ),
            ]),
      ),
    );
  }
}
