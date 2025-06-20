import 'package:cloud_firestore/cloud_firestore.dart';

class LogData 
{
    final String eventType;
    final DateTime timestamp;

    LogData({required this.eventType, required this.timestamp});

    factory LogData.fromJson(Map<String, dynamic> json)
    {
        return LogData(
            eventType: json['eventType'] as String,
            timestamp: _parseTimestamp(json['timestamp']),
        );
    }

    static DateTime _parseTimestamp(dynamic timestamp) 
    {
        if(timestamp is Timestamp) 
        {
            return timestamp.toDate(); 
        } 
        else if (timestamp is DateTime) 
        {
            return timestamp;
        } 
        else if (timestamp is String) 
        {
            return DateTime.parse(timestamp);
        } 
        else 
        {
            throw FormatException('Invalid timestamp format');
        }
    }

    Map<String, dynamic> toJson()
    {
        return {
            'eventType': eventType,
            'timestamp': timestamp
        };
    }
}