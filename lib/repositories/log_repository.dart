import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_guardian_final/models/log.dart';

abstract class AbstractLogRepository 
{  
  Stream<List<LogData>> getRealtimeLogs();  
  Future<List<LogData>> getLogs(DateTime? filterDate);
  Future<void> addTestData(List<LogData> logs); // Untuk seeding data uji  
}  

class LogRepository implements AbstractLogRepository
{    
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    @override  
    Stream<List<LogData>> getRealtimeLogs({DateTime? filterDate}) 
    {  
        CollectionReference logsRef = _db.collection('logs');
        Query query = logsRef;

        if (filterDate != null) 
        {
            final startOfDay = DateTime(filterDate.year, filterDate.month, filterDate.day);
            final endOfDay = startOfDay.add(const Duration(days: 1));

            query = logsRef
                .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
                .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay));
        }

        return query.snapshots().map((snapshot) => 
            snapshot.docs.map(_convertDoc).toList()
        );
    }  

    @override
    Future<List<LogData>> getLogs(DateTime? filterDate) async
    {
        Query query = _db.collection('logs');

        if(filterDate != null) 
        {
            final startOfDay = DateTime(filterDate.year, filterDate.month, filterDate.day);
            final endOfDay = startOfDay.add(const Duration(days: 1));

            query = query
                .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
                .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay));
        }

        final snapshot = await query.get();
        return snapshot.docs.map(_convertDoc).toList();
    }

    @override  
    Future<void> addTestData(List<LogData> logs) async 
    {  
        final batch = _db.batch();  
        for (final log in logs) 
        {  
            final docRef = _db.collection('logs').doc();  
            batch.set(docRef, log.toJson());  
        }  
        await batch.commit();  
    }  

    LogData _convertDoc(DocumentSnapshot doc) 
    {  
        return LogData.fromJson(doc.data()! as Map<String, dynamic>);  
    }  
}