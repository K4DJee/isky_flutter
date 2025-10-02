import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class qrCodePage extends StatefulWidget{
  const qrCodePage({super.key});
  
   @override
  State<qrCodePage> createState() => _qrCodePageState();
}

class _qrCodePageState extends State<qrCodePage>{
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сканирование'),
      ),
      body: Column(
        children: [
          MobileScanner(
            onDetect: (result) {
              print(result.barcodes.first.rawValue);
            },
          )
        ],
      ),
    );
  }
}