import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService 
{
    final FirebaseMessaging _messaging = FirebaseMessaging.instance;

    Future<String?> getDeviceToken() async 
    {
        try
        {
            String? token = await _messaging.getToken();
            return token;
        }
        catch(e)
        {
            print('Error getting token: $e');
            return null;
        }
    }

    Future<bool> getAuthorizationStatus() async 
    {
        final authorization = await _messaging.getNotificationSettings();
        return authorization.authorizationStatus == AuthorizationStatus.authorized;
    }

    // Future<void> initialize() async 
    // {
    //     await _messaging.requestPermission();

    //     FirebaseMessaging.onMessage.listen((RemoteMessage message) 
    //     {
    //         print('Received foreground message: ${message.notification?.title}');
    //     });
    // }
}