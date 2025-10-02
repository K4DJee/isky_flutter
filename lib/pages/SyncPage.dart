import 'package:flutter/material.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/pages/LocalSyncPage.dart';

class SyncPage extends StatefulWidget{
  const SyncPage({super.key});


  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Синхронизация'),
      ),
      body:Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Expanded(child: Column(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.localSync,
              style: TextStyle(fontSize: 18, fontWeight:FontWeight.w500),),
              trailing: Icon(Icons.keyboard_arrow_right),
              selectedTileColor: Colors.black,
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LocalSyncPage()));
              }

            ),
            ListTile(
              title: Text('Как происходит локальная синхронизация? Вы можете передать все свои папки другому устройству через точку доступа Wi-Fi или когда оба устройства подключены к одному и тому же wifi',
              style: TextStyle(fontSize: 18),),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.globalSync,
              style: TextStyle(fontSize: 18, fontWeight:FontWeight.w500)),
              trailing: Icon(Icons.keyboard_arrow_right),
              selectedTileColor: Colors.black,
              onTap:(){
                
              }
            ),
            ListTile(
              title: Text('Передача папок со словами происходит через сервер, который служит посредником между двумя устройствами. Сервер не хранит никакие данные, он только переотправляет базу данных',
              style: TextStyle(fontSize: 18),),
            ),
          ],
        ),)
      ],),)
    );
  }
}