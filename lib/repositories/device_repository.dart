import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceRepository 
{
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<bool> findById(String id) async
    {
        try
        {
            final querySnapshot = await _db.collection('devices').where('id', isEqualTo: id).limit(1).get();
            return querySnapshot.docs.isNotEmpty;
        }
        catch(e)
        {
            throw Exception('Failed to check device existence: $e');
        }
    }
}