// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:get_storage/get_storage.dart';
// import '../models/user_model.dart';
//
// class AuthService extends GetxService {
//   static AuthService get to => Get.find();
//
//   final Rx<User?> currentUser = Rx<User?>(null);
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   final String baseUrl = 'https://uat.goclaims.in/inventory_hub';
//
//   final _storage = GetStorage(); // Using GetStorage instead of SharedPreferences
//
//   bool get isLoggedIn => currentUser.value != null;
//   String? get refId => currentUser.value?.refId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkAuthStatus();
//   }
//
//   Future<void> checkAuthStatus() async {
//     isLoading.value = true;
//     try {
//       final storedRefId = _storage.read('auth_ref_id');
//       final userData = _storage.read('user_data');
//
//       if (storedRefId != null && userData != null) {
//         final isValid = await validateToken(storedRefId);
//
//         if (isValid) {
//           currentUser.value = User.fromJson(jsonDecode(userData));
//         } else {
//           await logout(clearStorageOnly: true);
//         }
//       }
//     } catch (e) {
//       print('Error checking auth status: $e');
//       errorMessage.value = 'Session restoration failed';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> validateToken(String refId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/validate_token'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'ref_id': refId}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['success'] == true;
//       }
//       return false;
//     } catch (e) {
//       print('Token validation error: $e');
//       return false;
//     }
//   }
//
//   Future<bool> login(String username, String password) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/mobile_auth_login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'password': password,
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && data['success'] == true) {
//         final user = User(
//           id: data['ref_id'] ?? '',
//           refId: data['ref_id'],
//           name: data['user_name'] ?? '',
//           role: data['user_role'] ?? '',
//           lastLoggedIn: data['last_logged_in'] ?? '',
//           isLoggedIn: data['is_logged_in'] ?? false,
//         );
//
//         currentUser.value = user;
//
//         await _saveUserSession(user); // Save user in GetStorage
//
//         return true;
//       } else {
//         errorMessage.value = data['message'] ?? 'Authentication failed';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = 'Network or server error occurred';
//       print('Login error: $e');
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _saveUserSession(User user) async {
//     try {
//       _storage.write('auth_ref_id', user.refId ?? '');
//       _storage.write('user_data', jsonEncode(user.toJson()));
//     } catch (e) {
//       print('Error saving user session: $e');
//     }
//   }
//
//   Future<void> logout({bool clearStorageOnly = false}) async {
//     try {
//       if (!clearStorageOnly && refId != null) {
//         await http.post(
//           Uri.parse('$baseUrl/logout'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'ref_id': refId}),
//         );
//       }
//     } catch (e) {
//       print('Logout API error: $e');
//     } finally {
//       _storage.remove('auth_ref_id');
//       _storage.remove('user_data');
//
//       currentUser.value = null;
//
//       if (!clearStorageOnly) {
//         Get.offAllNamed('/login');
//       }
//     }
//   }
// }


import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String baseUrl = 'https://uat.goclaims.in/inventory_hub';

  final _storage = GetStorage(); // Using GetStorage instead of SharedPreferences

  bool get isLoggedIn => currentUser.value != null;
  String? get refId => currentUser.value?.refId;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    try {
      final storedRefId = _storage.read('auth_ref_id');
      final userData = _storage.read('user_data');

      if (storedRefId != null && userData != null) {
        // ✅ If ref_id is present, assume the user is logged in
        currentUser.value = User.fromJson(jsonDecode(userData));
      } else {
        // If ref_id is not present, log the user out
        await logout(clearStorageOnly: true);
      }
    } catch (e) {
      print('Error checking auth status: $e');
      errorMessage.value = 'Session restoration failed';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mobile_auth_login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = User(
          id: data['ref_id'] ?? '',
          refId: data['ref_id'],
          name: data['user_name'] ?? '',
          role: data['user_role'] ?? '',
          lastLoggedIn: data['last_logged_in'] ?? '',
          isLoggedIn: data['is_logged_in'] ?? false,
        );

        currentUser.value = user;

        await _saveUserSession(user); // Save user in GetStorage

        return true;
      } else {
        errorMessage.value = data['message'] ?? 'Authentication failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Network or server error occurred';
      print('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserSession(User user) async {
    try {
      _storage.write('auth_ref_id', user.refId ?? '');
      _storage.write('user_data', jsonEncode(user.toJson()));
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  Future<void> logout({bool clearStorageOnly = false}) async {
    try {
      /* ✅ Commented out the logout API call for now
      if (!clearStorageOnly && refId != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'ref_id': refId}),
        );
      }
      */

    } catch (e) {
      print('Logout API error: $e');
    } finally {
      _storage.remove('auth_ref_id');
      _storage.remove('user_data');

      currentUser.value = null;

      if (!clearStorageOnly) {
        Get.offAllNamed('/login');
      }
    }
  }
}
