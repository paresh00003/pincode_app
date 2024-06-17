import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/pincode_class.dart';
import 'dart:convert';

class SavedPage extends StatelessWidget {
  final List<PincodeDetails> favoritesList;
  final Function(List<PincodeDetails>) updateFavorites;

  const SavedPage({Key? key, required this.favoritesList, required this.updateFavorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoritesList.isEmpty
          ? Center(
        child: Text('No favorites added yet'),
      )
          : ListView.builder(
        itemCount: favoritesList.length,
        itemBuilder: (context, index) {
          PincodeDetails result = favoritesList[index];
          return ListTile(
            title: Text(result.name),
            subtitle: Text('${result.district}, ${result.state}'),
            leading: Text(result.pincode.toString()),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                _showRemoveDialog(context, result);
              },
            ),
          );
        },
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, PincodeDetails pincodeDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Favorite'),
          content: Text('Are you sure you want to remove this favorite?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                Navigator.of(context).pop();
                _removeFromFavorites(pincodeDetails);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeFromFavorites(PincodeDetails pincodeDetails) async {
    List<PincodeDetails> updatedFavorites = List<PincodeDetails>.from(favoritesList);
    updatedFavorites.remove(pincodeDetails);
    updateFavorites(updatedFavorites);
    await _saveFavorites(updatedFavorites);
  }

  Future<void> _saveFavorites(List<PincodeDetails> favoritesList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoritesJson = jsonEncode(favoritesList.map((item) => item.toJson()).toList());
    await prefs.setString('favorites', favoritesJson);
  }
}
