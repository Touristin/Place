import 'package:flutter/material.dart';
import 'place_details.dart';

class FavoritesTab extends StatefulWidget {
  final List<dynamic> favoritePlaces;

  FavoritesTab({required this.favoritePlaces});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные места'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // add padding to the container
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.favoritePlaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          'Name: ${widget.favoritePlaces[index].name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Address: ${widget.favoritePlaces[index].addressName}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlaceDetail(placeId: widget.favoritePlaces[index].id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}