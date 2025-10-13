import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:sqflite/sqflite.dart';
import '../sync/tcpSender.dart';
import '../sync/tcpReceiver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LocalSyncPage extends StatefulWidget{
  const LocalSyncPage({super.key});

  @override
  State<LocalSyncPage> createState() => _LocalSyncPageState();
}

class _LocalSyncPageState extends State<LocalSyncPage>{
   TcpSender sender =  TcpSender();
   TcpReceiver receiver =  TcpReceiver();
    String? ipHost;
    late String? uIpHost;
    String _status = 'Сервер выключен';

  @override
  void initState() {
    super.initState();
    uIpHost = null;
  }

  Future<void> receiveData() async{
    uIpHost = await receiver.getServerIp();
    if(uIpHost != null){
      print("Получен IP: $uIpHost");
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ваш ip: $uIpHost'),),
      );
      setState(() {
        _status = 'Сервер включён. IP: $uIpHost';
      });
      try{
        await receiver.startServer();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Данные успешно приняты'),
          backgroundColor: Colors.green,
        ),
    );
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Не удалось получить IP. Проверьте Wi-Fi.'),),
    );
      setState(() {
        _status = 'Ошибка получения IP';
      });
    }
  }

  Future<void> sendData()async{
    if(ipHost == null || ipHost!.isEmpty){
       print('Введите ip');
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Введите IP-адрес получателя'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
    }
    try{
      await sender.sendJson(ipHost!);
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Данные успешно отправлены'),
        backgroundColor: Colors.green,
      ),
    );
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Ошибка: $e'),
        backgroundColor: Colors.red,
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.localSync),
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_status),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                await receiveData();
              },
              child: Text('Получить'),
            ),
            SizedBox(height: 10),

            if (uIpHost != null ) ...[
              Text('Ваш QR-код для передачи IP:'),
              SizedBox(height: 8),
              QrImageView(
                data: uIpHost!,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ] else ...[
              Container(
                height: 200,
                child: Center(
                  child: Text('Нажмите "Получить", чтобы сгенерировать QR-код'),
                ),
              ),
            ],
            
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "Ip адрес получителя",
                border: OutlineInputBorder()
              ),
              onChanged: (value) => {
                setState(() {
                  ipHost = value;
                })
              },
            ),
            
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async{
                await sendData();
              },
              child: Text('Отправить данные'),
            ),
             SizedBox(height: 10),
          ],
        ),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
            icon: Icon(Icons.qr_code), 
            label: 'Показать QR код',
            ), 
            NavigationDestination(
            icon: Icon(Icons.qr_code_scanner), 
            label: 'Сканировать QR код',
            ), 
          ], 
          onDestinationSelected: (index) {
          //logic
          
        },
          )
    );
  }
}


class Device {
  final String deviceId;
  final String deviceName;

  Device({required this.deviceId, required this.deviceName});
}