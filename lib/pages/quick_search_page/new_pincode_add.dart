import 'package:flutter/material.dart';
import '../../api_service/api_service.dart';
import '../../firebase_service_class/firebase_service.dart';
import '../../model/pincode_class.dart';

class PincodePage extends StatelessWidget {
  final TextEditingController _pincodeController = TextEditingController();
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Pincode Details'),


      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _pincodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Pincode',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),



              GestureDetector(
                onTap: () async {

                  String pincode = _pincodeController.text.trim();
                  if (pincode.isNotEmpty) {
                    print("Fetching pincode details for: $pincode");
                    PincodeDetails? pincodeDetails = await _apiService.fetchPincodeDetails(pincode);
                    if (pincodeDetails != null) {
                      print("Fetched pincode details: ${pincodeDetails.toJson()}");
                      await _firebaseService.addPincodeDetailsIfNotExists(pincodeDetails);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pincode details added to Firebase')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to fetch pincode details')),
                      );
                    }
                  }
                },

                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
