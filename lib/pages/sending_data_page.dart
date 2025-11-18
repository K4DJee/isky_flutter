import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/sync/tcpSender.dart';

class SendingDataPage extends StatefulWidget {
  final String ipAddress;
  const SendingDataPage({super.key, required this.ipAddress});

  @override
  State<SendingDataPage> createState() => _SendingDataPageState();
}

class _SendingDataPageState extends State<SendingDataPage>{
  bool _isSuccess = false;
  bool _isError = false;
  String? _errorMessage;

  @override
  void initState(){
    super.initState();
    _sendData();
  }

   Future<void> _sendData() async {
    try {
      final sender = TcpSender();
      await sender.sendJson(widget.ipAddress);
      if (mounted) {
        setState(() => _isSuccess = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: Center(
      child: _isSuccess
            ? _buildSuccessView()
            : _isError
                ? _buildErrorView()
                : _buildLoadingView(),
      ),
    );
  }

  Widget _buildLoadingView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.sendingDataToRecipent, 
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        ),
         SizedBox(height: 8),
        Text(
          'IP: ${widget.ipAddress}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
  Widget _buildSuccessView(){
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle, color: Colors.green, size: 64,),
      SizedBox(height: 24),
      Text(
          AppLocalizations.of(context)!.dataSentSuccessfully,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.exitBtn),
        ),
    ],
    );
  }
  Widget _buildErrorView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error, color: Colors.red, size: 64),
        SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.dataFailedSent,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          _errorMessage ?? AppLocalizations.of(context)!.unknownError,
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _sendData, // повторить
          child: Text(AppLocalizations.of(context)!.retrySend),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelSend),
        ),
      ],
    );
  }
}