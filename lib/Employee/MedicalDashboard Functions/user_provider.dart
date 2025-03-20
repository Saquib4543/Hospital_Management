import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _referenceId;
  String? _username;

  String? get referenceId => _referenceId;
  String? get username => _username;
  String get firstName => _username?.split(' ')[0] ?? "User";

  /// Save Reference ID to Provider
  void saveReferenceId(String referenceId) {
    _referenceId = referenceId;
    notifyListeners();
  }

  /// Save Username to SharedPreferences
  Future<void> saveUsername(String username) async {
    _username = username;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  /// Load Username from SharedPreferences when the app starts
  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    notifyListeners();
  }
}