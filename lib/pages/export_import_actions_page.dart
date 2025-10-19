import 'package:flutter/material.dart';
import 'package:isky_new/pages/export_data_page.dart';

class ExportImportActionsPage extends StatefulWidget{
  const ExportImportActionsPage({super.key});

  @override
  State<ExportImportActionsPage> createState() => _ExportImportActionsPageState();
}

class _ExportImportActionsPageState extends State<ExportImportActionsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ExportDataPage()));
            },
            title: Text('Экспорт данных'),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            onTap: (){
              
            },
            title: Text('Импорт данных'),
          )
        ],
      ),
    );
  }
}