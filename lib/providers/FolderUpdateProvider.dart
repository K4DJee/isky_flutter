
import 'package:flutter/foundation.dart';

class FolderUpdateProvider with ChangeNotifier {
  void notifyFolderUpdated() {
    notifyListeners();
  }
}