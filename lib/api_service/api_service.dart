import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pincode_class.dart';

class ApiService {
  Future<PincodeDetails?> fetchPincodeDetails(String pincode) async {
    final response = await http.get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty && data[0]['Status'] == 'Success') {
        print("Fetched data from API: ${data[0]['PostOffice'][0]}");
        try {
          return PincodeDetails.fromJson(data[0]['PostOffice'][0]);
        } catch (e) {
          print('Error in fromJson: $e');
        }
      }
    }
    return null;
  }
}
