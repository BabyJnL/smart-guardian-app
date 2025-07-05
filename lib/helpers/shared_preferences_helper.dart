import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_guardian_final/models/log.dart';

class SharedPreferencesHelper {
    // Instance Singleton
    static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();

    factory SharedPreferencesHelper() 
    {
        return _instance;
    }

    SharedPreferencesHelper._internal();

    static SharedPreferences? _preferences;

    // Inisialisasi SharedPreferences
    Future<void> init() async 
    {
        if(_preferences == null) {
            _preferences = await SharedPreferences.getInstance();
        }
    }

    // Simpan nilai ke SharedPreferences
    Future<void> setDeviceID(String deviceID) async 
    {
        await _preferences?.setString('deviceID', deviceID);
    }

    // Ambil nilai dari SharedPreferences
    String? getDeviceID() 
    {
        return _preferences?.getString('deviceID');
    }

    // Hapus nilai dari SharedPreferences
    Future<void> removeDeviceID() async 
    {
        await _preferences?.remove('deviceID');
    }

    Future<void> saveLastActive() async
    {
        await _preferences?.setInt('lastActiveMillis', DateTime.now().millisecondsSinceEpoch);
    }

    Future<DateTime?> getLastActive() async 
    {
        final millis = await _preferences?.getInt('lastActiveMillis');
        if(millis == null)
            return null;
        return DateTime.fromMillisecondsSinceEpoch(millis);
    }

    Future<void> saveStreamUri(String uri) async
    {
        await _preferences?.setString('streamUri', uri);
    }

    String? getStreamUri()
    {
        return _preferences?.getString('streamUri');
    }
}
