import 'package:flutter/material.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/models/folders.dart';

class FolderNamePage extends StatefulWidget {
  final Folders folder;
  final Function(Folders) onSave;
  final TextEditingController controller;
  const FolderNamePage({
  required this.folder,
  required this.controller,
  required this.onSave,
  });

  @override
  State<FolderNamePage> createState() => _FolderNamePageState();
}

class _FolderNamePageState extends State<FolderNamePage>{

  @override
  void initState() {
    super.initState();
   widget.controller.text = widget.folder.name;
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text('Изменение названия папки'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            final updatedFolder = Folders(
              id:widget.folder.id,
              name: widget.controller.text.trim(),
            );
            widget.onSave(updatedFolder);
          },
          style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ), child:  Text(AppLocalizations.of(context)!.showBottomSheetChange)),
            const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
           Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ), child:  Text(AppLocalizations.of(context)!.closeButton))
        ],
      ),
    ),
   );
  }
}