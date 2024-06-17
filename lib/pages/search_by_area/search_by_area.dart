import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase_service_class/firebase_service.dart';
import '../../model/pincode_class.dart';


class SearchByAreaPage extends StatefulWidget {
  const SearchByAreaPage({Key? key, required void Function(List<PincodeDetails> updatedFavorites) updateFavorites, required List<PincodeDetails> favoritesList}) : super(key: key);

  @override
  State<SearchByAreaPage> createState() => _SearchByAreaPageState();
}

class _SearchByAreaPageState extends State<SearchByAreaPage> {
  final FirebaseService _firebaseService = FirebaseService();

  final _formKey = GlobalKey<FormState>();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedPincode;

  List<String> _states = [];
  List<String> _districts = [];
  List<String> _pincodes = [];

  List<PincodeDetails> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchStates() async {
    try {
      List<String> states = await _firebaseService.getStates();
      setState(() {
        _states = states;
      });
    } catch (e) {
      print('Error fetching states: $e');
    }
  }

  Future<void> _fetchDistricts(String state) async {
    try {
      List<String> districts = await _firebaseService.getDistricts(state);
      setState(() {
        _districts = districts;
      });
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  Future<void> _fetchPincodes(String state, String district) async {
    try {
      List<String> pincodes = await _firebaseService.getPincodes(state, district);
      setState(() {
        _pincodes = pincodes;
      });
    } catch (e) {
      print('Error fetching pincodes: $e');
    }
  }

  Future<void> _searchByArea() async {
    try {
      if (_selectedPincode != null) {
        _firebaseService.searchByPincode(_selectedPincode!).listen((List<PincodeDetails> data) {
          setState(() {
            _searchResults = data;
          });
        });
      } else if (_selectedDistrict != null && _selectedState != null) {
        _firebaseService.searchByStateAndDistrict(_selectedState!, _selectedDistrict!).listen((List<PincodeDetails> data) {
          setState(() {
            _searchResults = data;
          });
        });
      } else {
        // Handle case where no valid selection is made
        setState(() {
          _searchResults = [];
        });
      }
    } catch (e) {
      print('Error searching by area: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search By Area'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select State:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  hint: const Text('Select State'),
                  items: _states.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                      _selectedDistrict = null;
                      _selectedPincode = null;
                      _districts.clear();
                      _pincodes.clear();
                      _fetchDistricts(value!);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select District:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDistrict,
                  hint: const Text('Select District'),
                  items: _districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                      _selectedPincode = null;
                      _pincodes.clear();
                      _fetchPincodes(_selectedState!, value!);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Pincode:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPincode,
                  hint: const Text('Select Pincode'),
                  items: _pincodes.map((pincode) {
                    return DropdownMenuItem<String>(
                      value: pincode,
                      child: Text(pincode),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPincode = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a pincode';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _searchByArea();
                    }
                  },
                  child: const Text('Search'),
                ),
                const SizedBox(height: 24),
                _buildSearchResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Text('No results found.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Results:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: Container(


                  decoration: BoxDecoration(

                    color: Colors.grey.shade300,

                   border: Border(
                     bottom: BorderSide(
                       color: Colors.black12
                     )
                   )
                  ),
                  
                  
                  
                  child: Column(
                  
                    children: [
                  
                  
                      Text('Pincode:           ${_searchResults[index].pincode}'),
                      Text('District:          ${_searchResults[index].district}'),
                      Text('Name:           ${_searchResults[index].name}'),
                      Text('Block:          ${_searchResults[index].block}'),
                      Text('BranchType:           ${_searchResults[index].branchType}'),
                      Text('Circle:          ${_searchResults[index].circle}'),
                      Text('DeliveryStatus:           ${_searchResults[index].deliveryStatus}'),
                      Text('Description:          ${_searchResults[index].description}'),
                      Text('Devision:           ${_searchResults[index].division}'),
                      Text('State:          ${_searchResults[index].state}'),
                      Text('Country:           ${_searchResults[index].country}'),
                      Text('Region:          ${_searchResults[index].region}'),
                  
                  
                    ],
                  ),
                ),
              );


            },
          ),
        ],
      );
    }
  }
}
