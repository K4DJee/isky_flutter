import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';

class ReceiveDataPage extends StatefulWidget {
  final bool receiveStatus;
  const ReceiveDataPage({super.key, required this.receiveStatus});

  @override
  State<ReceiveDataPage> createState() => _ReceiveDataPageState();
}

class _ReceiveDataPageState extends State<ReceiveDataPage>{
  bool _isSuccess = false;
  bool _isError = false;
  String? _errorMessage;

  @override
  void initState(){
    super.initState();
    checkReceiveStatus();
  }

 void checkReceiveStatus(){
  if(widget.receiveStatus == true){
    setState(() {
      _isSuccess = true;
    });
  }
  else{
    setState(() {
      _isError = true;
    });
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
        Text(AppLocalizations.of(context)!.dataReceiveLoad, 
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancelSend),
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
          AppLocalizations.of(context)!.dataReceiveSuccess,
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
          onPressed: ()=> Navigator.pop, // retry
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