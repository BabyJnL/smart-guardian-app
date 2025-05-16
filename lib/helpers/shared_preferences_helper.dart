import 'package:shared_preferences/shared_preferences.dart';

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

    Future<void> saveLastOpenedTime() async 
    {
        print("Saving last opened time: ${DateTime.now().millisecondsSinceEpoch}");
        await _preferences?.setInt('lastOpened', DateTime.now().millisecondsSinceEpoch);
    }

    Future<int?> getLastOpenedTime() async 
    {
        return _preferences?.getInt('lastOpened');
    }
}
