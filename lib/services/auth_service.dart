import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  // password Hashing
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> signup(String email, String password) async{
    try {
      final hashed = _hashPassword(password);
      await _dbHelper.insertUser(email, hashed);
      return true;
    } catch (e) {
      return false;     // In case email already exists
    }
  }

  Future<bool> login(String email, String password) async {
    final hashed = _hashPassword(password);
    final user = await _dbHelper.getUser(email, hashed);
    if(user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    final db = await _dbHelper.database; // Access db from DBHelper
    final hashedPassword = _hashPassword(newPassword); // Hash it
    final result = await db.update(
      'users',
      {'password': hashedPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
    return result > 0;
  }

}