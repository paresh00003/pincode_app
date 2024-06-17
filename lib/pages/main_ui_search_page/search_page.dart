import 'package:flutter/material.dart';
import '../quick_search_page/new_pincode_add.dart';
import '../quick_search_page/quick_search.dart';
import '../saved_page/saved_page.dart';
import '../search_by_area/search_by_area.dart';
import '../../model/pincode_class.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PincodeDetails> favoritesList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          title: Text('Pincode App'),

          bottom: TabBar(

            indicatorColor: Colors.white,

            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text('Quick Search',style: TextStyle(

                      color: Colors.white
                    ),),
                  ],
                ),
              ),
              Tab(
                child: Text('Search By Area',style: TextStyle(
                  color: Colors.white
                ),),
              ),
              Tab(
                child: Text('Saved Search',style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => handleMenuItemClick(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Enter Pincode')),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            QuickSearchTab(
              updateFavorites: _updateFavorites,
              favoritesList: favoritesList,
            ),
            SearchByAreaPage(
              updateFavorites: _updateFavorites,
              favoritesList: favoritesList,
            ),
            SavedPage(
              favoritesList: favoritesList,
              updateFavorites: _updateFavorites,
            ),
          ],
        ),
      ),
    );
  }

  void handleMenuItemClick(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PincodePage()),
        ).then((value) {

        });
        break;
    }
  }

  void _updateFavorites(List<PincodeDetails> updatedFavorites) {
    setState(() {
      favoritesList = updatedFavorites;
    });
  }
}
