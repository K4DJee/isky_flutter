import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'dart:convert';

class TcpSender {
  Future<void> sendJson(String serverIp) async{
    try{
      String jsonString = await SQLiteDatabase.instance.exportDatabaseToJson();
      final socket = await Socket.connect(serverIp,8082);
      print("📤 Подключено к $serverIp:8082");

      socket.add(utf8.encode(jsonString));
      await socket.flush();
      await socket.close();
      print("✅ Данные успешно отправлены");

    }
    catch(e){
      print("❌ Ошибка подключения: $e");
      rethrow;
    }
  }
}