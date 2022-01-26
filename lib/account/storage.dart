import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:passengerapp/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum _Actions { deleteAll }
enum ItemActions { delete, edit, containsKey, removeAccount }

class StorageTester {
  void startTest() {
    var item = SecItem("phone", "0922877115");
  }
}

class DataStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> _readAll() async {
    final all = await _storage.readAll(
        iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
  }
  Future<String> loadItem(SecItem item) async {
    var result =  await _storage.read(key: item.key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    return result!;
  }
  void _addNewItem() async {
    final String key = _randomValue();
    final String value = _randomValue();

    await _storage.write(
        key: key,
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    //_readAll();
  }

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getAccountName(),
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> performAction(ItemActions action, SecItem item) async {
    switch (action) {
      case ItemActions.delete:
        await _storage.delete(
            key: item.key,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions());

        break;
      case ItemActions.edit:
        await _storage.write(
            key: item.key,
            value: item.value,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions());
        //_readAll();
        break;
      case ItemActions.removeAccount:
        await _storage.deleteAll(
            iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
        //_readAll();

        break;
      case ItemActions.containsKey:
        await _storage.containsKey(key: item.key);
        /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contains Key: $result'),
          // backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ));*/
        break;
    }
  }

  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }

  String _getAccountName() {
    return "ios";
  }
}
