import 'package:network_info_plus/network_info_plus.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';

class TcpReceiver {
  Future<void> startServer() async{
    if(await Permission.location.request().isGranted){
      final info = NetworkInfo();
    //Найти ip
    String? localIp = await info.getWifiIP();
    print("Локальный IP: $localIp");
    try{
    final server = await ServerSocket.bind(InternetAddress(localIp!), 8082);

    print("📡 Сервер запущен на $localIp:8082. Ждём подключения...");

    await for (Socket socket in server) {
    print("✅ Подключено: ${socket.remoteAddress.address}");

    socket.listen(
      (data) async{
        final jsonString = utf8.decode(data);
        print("📥 Получено ${jsonString.length} символов");
        // Импортируйте в БД
        await SQLiteDatabase.instance.importJsonToDatabase(jsonString);
        socket.close();
        server.close();
      },
      onDone: () => print("Соединение закрыто"),
      onError: (e) => print("Ошибка: $e"),
    );
    }
  }
   catch(e, stack){
      print('Ошибка создания сервера: $e');
      print('Стек вызовов: $stack');
      rethrow;  
    }
    }
    else{
      print('request inDenied');
    }
    
  }

  Future<String?> getServerIp() async{
      final info = NetworkInfo();
      String? localIp = await info.getWifiIP();
      return localIp;
  }
}