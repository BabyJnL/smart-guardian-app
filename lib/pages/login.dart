import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:smart_guardian_final/helpers/shared_preferences_helper.dart';
import 'package:smart_guardian_final/services/messaging_service.dart';

// Import Service & Repository
import '../services/auth_service.dart';
import '../repositories/device_repository.dart';

// Import Pages
import 'package:smart_guardian_final/tab/tab_view.dart';

class LoginPage extends StatefulWidget
{
    const LoginPage({ super.key });

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    final _deviceIdController = TextEditingController();
    final _authService = AuthService(DeviceRepository());

    bool _isLoading = false;

    void _login() async {
        setState(() {
            _isLoading = true;
        });

        try 
        {
            final notifPermissionGranted = await MessagingService().getAuthorizationStatus();
            if(!notifPermissionGranted)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('You need to grant notification permission to use this app. Please go to settings and grant permission.'),  
                        backgroundColor: Colors.red,
                    ),
                );
                return;
            }

            final String deviceId = _deviceIdController.text.trim();
            final authSuccess = await _authService.loginWithDeviceId(deviceId);

            if(authSuccess) 
            {
                FirebaseMessaging.instance.subscribeToTopic('deteksi-suara');
                await SharedPreferencesHelper().setDeviceID(deviceId);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Login berhasil!'),  
                        backgroundColor: Colors.green,
                    ),
                );
                await Future.delayed(Duration(seconds: 2));
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const TabView(),
                    ),
                );
            } 
            else 
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Device ID tidak ditemukan.'),
                        backgroundColor: Colors.red,
                    ),
                );
            }
        } 
        catch (e) 
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Terjadi kesalahan: $e'),
                    backgroundColor: Colors.red,
                ),
            );
        }
        finally 
        {
            setState(() {
                _isLoading = false;
            });
        }
    }

    @override
    void dispose() 
    {
        _deviceIdController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Image(image: AssetImage('assets/app_logo.png'), width: 175),
                        SizedBox(height: 25),
                        Text(
                            'Smart Guardian v1.0',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                            child: TextFormField(
                                controller: _deviceIdController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(123, 185, 224, 1)), // saat fokus
                                        ),
                                    labelText: 'Enter Device ID',
                                ),
                            ),
                        ),
                        SizedBox(height: 35),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(123, 185, 224, 1),
                                foregroundColor: Colors.white,
                                fixedSize: Size(175, 45),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                side: BorderSide(color: Colors.white)
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        )
                    ],
                ),
            )
        );
    }   
}