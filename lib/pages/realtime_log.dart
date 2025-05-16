import 'package:flutter/material.dart';

class RealtimeLogPage extends StatefulWidget 
{
    const RealtimeLogPage({Key? key}) : super(key: key);

    @override
    State<RealtimeLogPage> createState() => _RealtimeLogState();
}

class _RealtimeLogState extends State<RealtimeLogPage> 
{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text('Realtime Log'),
            ),
        );
    }
}