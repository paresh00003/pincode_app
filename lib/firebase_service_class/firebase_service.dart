import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/pincode_class.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PincodeDetails>> searchByPincode(String pincode) {
    return _firestore
        .collection('pincodes')
        .where('Pincode', isEqualTo: int.tryParse(pincode) ?? -1)
        .snapshots()
        .map(_mapSnapshotToPincodeDetails);
  }

  Stream<List<PincodeDetails>> searchByPartialPincode(String partialPincode) {
    int startRange = int.tryParse(partialPincode) ?? -1;
    int endRange = int.tryParse(partialPincode + '9') ?? -1;
    if (startRange == -1 || endRange == -1) {
      return Stream.value([]);
    }
    return _firestore
        .collection('pincodes')
        .where('Pincode', isGreaterThanOrEqualTo: startRange)
        .where('Pincode', isLessThanOrEqualTo: endRange)
        .snapshots()
        .map(_mapSnapshotToPincodeDetails);
  }

  Stream<List<PincodeDetails>> searchByDistrict(String district) {
    return _firestore
        .collection('pincodes')
        .where('District', isEqualTo: _normalizeString(district))
        .snapshots()
        .map(_mapSnapshotToPincodeDetails);
  }

  Stream<List<PincodeDetails>> searchByStateAndDistrict(String state, String district) {
    return _firestore
        .collection('pincodes')
        .where('State', isEqualTo: state)
        .where('District', isEqualTo: district)
        .snapshots()
        .map(_mapSnapshotToPincodeDetails);
  }

  Stream<List<PincodeDetails>> searchByName(String name) {
    return _firestore
        .collection('pincodes')
        .where('Name', isEqualTo: _normalizeString(name))
        .snapshots()
        .map(_mapSnapshotToPincodeDetails);
  }

  Future<void> addPincodeDetails(PincodeDetails pincodeDetails) async {
    try {
      await _firestore
          .collection('pincodes')
          .doc(pincodeDetails.pincode.toString())
          .set(pincodeDetails.toJson());
    } catch (e) {
      print('Error adding pincode details: $e');
      rethrow;
    }
  }

  Future<void> addPincodeDetailsIfNotExists(PincodeDetails pincodeDetails) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('pincodes')
          .doc(pincodeDetails.pincode.toString())
          .get();
      if (!documentSnapshot.exists) {
        await _firestore
            .collection('pincodes')
            .doc(pincodeDetails.pincode.toString())
            .set(pincodeDetails.toJson());
      }
    } catch (e) {
      print('Error adding pincode details if not exists: $e');
      rethrow;
    }
  }

  Stream<List<PincodeDetails>> getAllPincodeDetails() {
    return _firestore.collection('pincodes').snapshots().map(_mapSnapshotToPincodeDetails);
  }

  List<PincodeDetails> _mapSnapshotToPincodeDetails(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PincodeDetails.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  String _normalizeString(String str) {
    return str.toLowerCase().trim();
  }

  Future<List<String>> getStates() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pincodes').get();
      Set<String> statesSet = snapshot.docs.map((doc) => doc['State'] as String).toSet();
      return statesSet.toList();
    } catch (e) {
      print('Error fetching states: $e');
      return [];
    }
  }

  Future<List<String>> getDistricts(String state) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('pincodes')
          .where('State', isEqualTo: state)
          .get();
      Set<String> districtsSet =
      snapshot.docs.map((doc) => doc['District'] as String).toSet();
      return districtsSet.toList();
    } catch (e) {
      print('Error fetching districts: $e');
      return [];
    }
  }

  Future<List<String>> getPincodes(String state, String district) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('pincodes')
          .where('State', isEqualTo: state)
          .where('District', isEqualTo: district)
          .get();
      List<String> pincodesList =
      snapshot.docs.map((doc) => doc['Pincode'].toString()).toList();
      return pincodesList;
    } catch (e) {
      print('Error fetching pincodes: $e');
      return [];
    }
  }
}
