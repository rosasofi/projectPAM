import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class DataModel {
  @HiveField(0)
  String username;

  @HiveField(1)
  String? encryptedPassword;

  // This field is not stored in Hive
  late String password;

  DataModel({
    required this.username,
    required this.password,
    String? encryptedPassword,
  }) {
    this.encryptedPassword = encryptedPassword ?? encryptPassword(password);
  }

  // Factory method to create an instance from Hive data
  factory DataModel.fromHive(Map<String, dynamic> hiveData) {
    return DataModel(
      username: hiveData['username'] as String,
      password: hiveData['password'] as String,
      encryptedPassword: hiveData['encryptedPassword'] as String?,
    );
  }

  // Method to convert the object to Hive data
  Map<String, dynamic> toHive() {
    return {
      'username': username,
      'password': password,
      'encryptedPassword': encryptedPassword,
    };
  }

  // Instance method to encrypt the password

  // Static method to encrypt a password
  static String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

}
