import '../repositories/device_repository.dart';

class AuthService 
{
    final DeviceRepository _deviceRepository;

    AuthService(this._deviceRepository);

    Future<bool> loginWithDeviceId(String deviceId) async 
    {
        final exists = await _deviceRepository.findById(deviceId);

        if(!exists)
            return false;


        return true;
    }
}