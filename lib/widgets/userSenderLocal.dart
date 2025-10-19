import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/pages/sending_data_page.dart';
import 'package:isky_new/widgets/scanner_overlay_painter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UserSenderLocal extends StatefulWidget {
  const UserSenderLocal({super.key,});

  @override
  State<UserSenderLocal> createState() => _UserSenderLocalState();
}

class _UserSenderLocalState extends State<UserSenderLocal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _cornerAnimation;
  bool isDetectScanner = false;
  late TextEditingController _ipController;
 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _cornerAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _ipController = TextEditingController();
  }
  
  bool get isMobilePlatform {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}

  @override
  void dispose() {
    _animationController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  

  @override
  late String barCode;
  Widget build(BuildContext context) {
    final isMobile = isMobilePlatform;
    return Scaffold(
      extendBody: true,
      body: 
     isMobile ?
      LayoutBuilder(
        builder: (context, constraints) {
          final scanWindow = Rect.fromCenter(
            center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
            width: 250,
            height: 250,
          );
          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    print("Detected ${barcodes.length} barcodes");
                    setState(() {
                      isDetectScanner = true;
                    });
                    for (final barcode in barcodes) {
                      barCode = barcode.rawValue!;
                      print("Barcode found! Value: ${barcode.rawValue}");
                    }
                  } else {
                    print("No barcodes detected in this capture");
                  }
                },
                fit: BoxFit.cover,
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                ),
                scanWindow: scanWindow,
                overlayBuilder: (context, constraints) {
                  return CustomPaint(
                    size: constraints.biggest,
                    painter: ScannerOverlayPainter(scanWindow: scanWindow),
                  );
                },
              ),
              if (isDetectScanner)
                Positioned(
                  bottom: 155,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                    onPressed: ()async{
                      final bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SendingDataPage(ipAddress: barCode)));
                      if(result == true){
                        setState(() {
                          isDetectScanner = false;
                          barCode = '';
                        });
                      }
                    }, child: Text(
                      '${AppLocalizations.of(context)!.sendDataToLocalServerTitle} $barCode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // shadows: [
                        //   Shadow(
                        //     blurRadius: 10,
                        //     color: Colors.black.withOpacity(0.5),
                        //     offset: const Offset(0, 2),
                        //   ),
                        // ],
                      ),
                    ),)
                  ),
                ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.scanRecipientQRCode,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.5),
                          offset:  Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      )
      : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
              AppLocalizations.of(context)!.qrScanTitle,
              style: TextStyle( fontSize: 18),
            ),
            SizedBox(height:20),
            SizedBox(
              width: 400,
              child: TextField(
                controller: _ipController,
              decoration: InputDecoration(
                labelText: "Ip адрес получителя",
                border: OutlineInputBorder()
              ),
            ),
            ),
            SizedBox(height:15),
            ElevatedButton(onPressed: ()async{
              final String ip = _ipController.text.trim();
              if (ip.isEmpty) return;
              final bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SendingDataPage(ipAddress: ip)));
               if(result == true){
                        setState(() {
                          _ipController.clear();
                          FocusScope.of(context).unfocus();//убрать клавиатуру
                        });
                      }
            }, child: Text(AppLocalizations.of(context)!.sendData)),
             
            ],)
          ),
    );
  }
}
