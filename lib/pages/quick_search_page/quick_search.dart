import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_service_class/firebase_service.dart';
import '../../model/pincode_class.dart';
import '../saved_page/saved_page.dart';
import 'dart:convert';

class QuickSearchTab extends StatefulWidget {
  final Function(List<PincodeDetails>) updateFavorites;

  const QuickSearchTab({Key? key, required this.updateFavorites, required List<PincodeDetails> favoritesList}) : super(key: key);

  @override
  State<QuickSearchTab> createState() => _QuickSearchTabState();
}

class _QuickSearchTabState extends State<QuickSearchTab> {
  final List<String> quickSearchOptions = ['By PIN', 'By District', 'By Name'];
  String selectedOption = 'By PIN';
  TextEditingController _searchController = TextEditingController();
  String searchTerm = '';

  FirebaseService firebaseService = FirebaseService();
  final _debounce = BehaviorSubject<String>();
  List<PincodeDetails> favoritesList = []; // List to hold favorite items

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites from local storage
    _debounce
        .debounceTime(Duration(milliseconds: 500))
        .listen((value) {
      setState(() {
        searchTerm = value.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce.close();
    super.dispose();
  }

  void _updateSearchTerm(String value) {
    _debounce.add(value);
  }

  Stream<List<PincodeDetails>> _getInitialData(String option) {
    if (option == 'By PIN') {
      return firebaseService.getAllPincodeDetails();
    } else if (option == 'By District') {
      return firebaseService.getAllPincodeDetails();
    } else if (option == 'By Name') {
      return firebaseService.getAllPincodeDetails();
    }
    return Stream.value([]);
  }

  Stream<List<PincodeDetails>> _getFilteredData(String option, String searchTerm) {
    if (option == 'By PIN') {
      if (searchTerm.length == 6) {
        return firebaseService.searchByPincode(searchTerm);
      } else {
        return firebaseService.searchByPartialPincode(searchTerm);
      }
    } else if (option == 'By District') {
      return firebaseService.searchByDistrict(searchTerm);
    } else if (option == 'By Name') {
      return firebaseService.searchByName(searchTerm);
    }
    return Stream.value([]);
  }

  void _addToFavorites(PincodeDetails pincodeDetails) {
    setState(() {
      if (!favoritesList.contains(pincodeDetails)) {
        favoritesList.add(pincodeDetails);
        _saveFavorites();
        _showItemSavedSnackbar();
        widget.updateFavorites(favoritesList);
      }
    });
  }

  void _removeFromFavorites(PincodeDetails pincodeDetails) {
    setState(() {
      favoritesList.remove(pincodeDetails);
      _saveFavorites();
      widget.updateFavorites(favoritesList);
    });
  }

  void _showItemSavedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item saved to favorites!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToSavedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedPage(favoritesList: favoritesList, updateFavorites: widget.updateFavorites),
      ),
    );
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      List<dynamic> favoritesListDynamic = jsonDecode(favoritesJson);
      setState(() {
        favoritesList = favoritesListDynamic.map((item) => PincodeDetails.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoritesJson = jsonEncode(favoritesList.map((item) => item.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10.0,
            children: quickSearchOptions.map((option) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        _searchController.clear();
                        searchTerm = '';
                      });
                    },
                  ),
                  Text(option),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Enter $selectedOption',
              border: OutlineInputBorder(),
            ),
            onChanged: _updateSearchTerm,
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<List<PincodeDetails>>(
              stream: searchTerm.isEmpty
                  ? _getInitialData(selectedOption)
                  : _getFilteredData(selectedOption, searchTerm),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No results found'));
                }

                List<PincodeDetails> results = snapshot.data!;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    PincodeDetails result = results[index];
                    bool isFavorite = favoritesList.contains(result);

                    return ListTile(
                      leading: Text(result.pincode.toString()),
                      title: Text(result.name),
                      subtitle: Text('${result.district}, ${result.state}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                _removeFromFavorites(result);
                              } else {
                                _addToFavorites(result);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Share logic
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.0),

        ],
      ),
    );
  }
}
