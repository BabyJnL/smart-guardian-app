import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget
{
    const LoginPage({ super.key });

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    final deviceIdController = TextEditingController();

    @override
    void dispose() 
    {
        deviceIdController.dispose();
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
                                controller: deviceIdController,
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
                            onPressed: () { },
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