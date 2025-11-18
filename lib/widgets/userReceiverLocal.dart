import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/pages/receive_data_page.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:iskai/sync/tcpReceiver.dart';
import 'package:iskai/sync/tcpSender.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserReceiverLocal extends StatefulWidget{
  const UserReceiverLocal({super.key});

  @override
  State<UserReceiverLocal> createState() => _UserReceiverLocalState();
}

class _UserReceiverLocalState extends State<UserReceiverLocal>{
  TcpSender sender =  TcpSender();
   TcpReceiver receiver =  TcpReceiver();
    late String? uIpHost;
    String _status = '';

  @override
  void initState() {
    super.initState();
    uIpHost = null;
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final localizations = AppLocalizations.of(context);
  if (localizations != null) {
    _status = localizations.localServerStatus1;
  } else {
    _status = AppLocalizations.of(context)!.localServerStatus1;
  }
}

  Future<void> receiveData() async{
    uIpHost = await receiver.getServerIp();
    if(uIpHost != null){
      // print("Получен IP: $uIpHost");
      setState(() {
        _status = '${AppLocalizations.of(context)!.localServerStatus2}. IP: $uIpHost';
      });
      try{
        await receiver.startServer();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.dataSuccessfullyAccepted),
          backgroundColor: Colors.green,
        ),
    );
    context.read<FolderUpdateProvider>().notifyFolderUpdated();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ReceiveDataPage(receiveStatus: true)));
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorTitle} $e'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ReceiveDataPage(receiveStatus: false)));
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.errorGettingIp),),
    );
      setState(() {
        _status = AppLocalizations.of(context)!.errorGettingIpStatus;
      });
    }
  }


  Future<void> _stopServer() async{
    try{
      receiver.stopServer();
      setState(() {
        uIpHost = null;
        _status = AppLocalizations.of(context)!.localServerStatus1;
      });
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorTitle} $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status),
            if(uIpHost == null)...[
               SizedBox(height: 8),
               ElevatedButton(
              onPressed: () async{
                await receiveData();
              },
              child: Text(AppLocalizations.of(context)!.receive),
            ),
            ],
            SizedBox(height: 10),

            if (uIpHost != null ) ...[
              Text(AppLocalizations.of(context)!.urQRCodeTitle),
              SizedBox(height: 8),
              Center(
                child: QrImageView(
                data: uIpHost!,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: (Colors.white),
              ),
              ),
              ElevatedButton(onPressed: (){
                _stopServer();
              }, child: Text(AppLocalizations.of(context)!.stopReceivingData))
            ] else ...[
              Container(
                child: Center(
                  child: Text(AppLocalizations.of(context)!.receiveTitle),
                ),
              ),
            ],
          ],
        ),
        );
  }
}