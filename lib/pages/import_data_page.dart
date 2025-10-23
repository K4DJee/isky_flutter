import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/l10n/app_localizations.dart';

class ImportDataPage extends StatefulWidget{
  const ImportDataPage({super.key});

  @override
  State<ImportDataPage> createState() => _ImportDataPageState();
}

class _ImportDataPageState extends State<ImportDataPage>{
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;
  String? errorMessage;

   bool isFile = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importingDataTile),
      ),
      body:  Center(
        child: _isLoading
        ? _buildLoadingView()
        : _isSuccess
          ? _buildSuccessView()
          : _isError
            ? _buildErrorView()
            : _uploadFileForImportView()
      ),
    );
  }

  Widget _uploadFileForImportView(){
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.selectFileForImport, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height:8),
            ElevatedButton(onPressed: 
            ()async{
              final result = await FilePicker.platform.pickFiles();
              if (result != null) {
                setState(() {
                  isFile = true;
                  _isLoading = true;
                });
                File file = File(result.files.single.path!);
                await SQLiteDatabase.instance.importDatabaseFromFile(file);
                setState(() {
                  _isLoading = false;
                  _isSuccess = true;
                });
              } else {
                isFile = false;
                return;
              }
            }, child: Text(AppLocalizations.of(context)!.selectFileTitle))
          ],
        );
  }

  Widget _buildLoadingView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height:8),
        Text(AppLocalizations.of(context)!.importLoad, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),),
        SizedBox(height:8),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }
  
  Widget _buildSuccessView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 64,),
        SizedBox(height:8),
        if(isFile == true)...[
          Text(AppLocalizations.of(context)!.importSuccess, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ]
        else...[  
          Text(AppLocalizations.of(context)!.importCanceled,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          )),
        ],
        SizedBox(height: 8,),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }

  Widget _buildErrorView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height:24),
        Text(AppLocalizations.of(context)!.importError),
        Text(AppLocalizations.of(context)!.errorTitle),
        SizedBox(),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.exitBtn)
         )
      ],
    );
  }
}