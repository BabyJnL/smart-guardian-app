import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:smart_guardian_final/models/log.dart';
import 'package:smart_guardian_final/repositories/log_repository.dart';
import 'package:smart_guardian_final/services/messaging_service.dart';

// Local Component
class RealtimeLogCard extends StatelessWidget
{
    final String eventType;
    final DateTime timestamp;
    final isRead = false;

    const RealtimeLogCard({ super.key, required this.eventType, required this.timestamp });

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        ListTile(
                            leading: Icon(Icons.notifications),
                            title: Text(eventType),
                            subtitle: Text(DateFormat('dd/MM/yyy HH:mm').format(timestamp)),
                        ),
                    ]
                )
            )   
        );
    }
}

class RealtimeLogPage extends StatefulWidget 
{
    const RealtimeLogPage({Key? key}) : super(key: key);

    @override
    State<RealtimeLogPage> createState() => _RealtimeLogState();
}

class _RealtimeLogState extends State<RealtimeLogPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver 
{
    TextEditingController _dateController = TextEditingController();
    final LogRepository _logRepository = LogRepository();

    DateTime? _selectedDate;
    bool _isLoading = false;
    List<LogData> _logs = [];

    Future<void> _selectDate() async
    {
        final DateTime? pickedDate = await showDatePicker(
            context: context, 
            initialDate: DateTime.now(),
            firstDate: DateTime(2025), 
            lastDate: DateTime(2030),
        );

        if(pickedDate != null)
        {
            setState(() {
                _selectedDate = pickedDate;
                _dateController.text = pickedDate.toString().split(' ')[0];
            });
        }
    }

    void _loadLogs() async 
    {
        try
        {
            setState(() {
                _isLoading = true;
            });
            final logs = await _logRepository.getLogs(_selectedDate);
            setState(() {
                _logs = logs;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Logs loaded successfully'),  
                    backgroundColor: Colors.green,
                ),
            );
        }
        catch(e)
        {
            print('Error loading logs: $e');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Something went wrong while loading logs'),  
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

    List<LogData> _filterLogs(List<LogData> logs) 
    {
        if(_selectedDate == null) 
            return logs;
        
        return logs.where((log) {
            final logDate = log.timestamp;
            return logDate.year == _selectedDate!.year &&
                logDate.month == _selectedDate!.month &&
                logDate.day == _selectedDate!.day;
        }).toList();
    }

    @override
    bool get wantKeepAlive => false;

    @override
    void initState()
    {
        super.initState();
        _selectedDate = DateTime.now(); 
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        _loadLogs();
    }

    @override
    void dispose()
    {
        _dateController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Scaffold(
            body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    children: [
                        TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                                labelText: 'Select Date Filter',
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)
                                ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(),
                        ),
                        SizedBox(height: 20),
                        // Expanded(
                        //     child: _isLoading ?
                        //         Center(child: CircularProgressIndicator()) :
                        //         _logs.isEmpty ?
                        //         Center(child: Text('No logs found for selected date')) :
                        //         ListView.separated(
                        //             itemCount: _logs.length,
                        //             separatorBuilder: (context, index) => SizedBox(height: 15),
                        //             itemBuilder: (context, index) 
                        //             {
                        //                 final log = _logs[index];
                        //                 return RealtimeLogCard(eventType: log.eventType, timestamp: log.timestamp);
                        //             },
                        //         )
                        // )
                        Expanded(
                            child: StreamBuilder<List<LogData>>(
                                stream: _logRepository.getRealtimeLogs(),
                                builder: (context, snapshot) {
                                    if(snapshot.connectionState == ConnectionState.waiting) 
                                    {
                                        return Center(child: CircularProgressIndicator());
                                    }
                                    
                                    if(snapshot.hasError) 
                                    {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                    }
                                    
                                    final logs = snapshot.data ?? [];
                                    final filteredLogs = _filterLogs(logs);

                                    filteredLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                                    if(filteredLogs.isEmpty) 
                                    {
                                        return Center(
                                            child: Text('No logs found for selected date')
                                        );
                                    }
                                    
                                    return ListView.separated(
                                        itemCount: filteredLogs.length,
                                        separatorBuilder: (context, index) => SizedBox(height: 15),
                                        itemBuilder: (context, index) {
                                            return RealtimeLogCard(
                                                eventType: filteredLogs[index].eventType,
                                                timestamp: filteredLogs[index].timestamp,
                                            );
                                        },
                                    );
                                },
                            ),
                        )
                    ],
                )
            )
        );
    }
}