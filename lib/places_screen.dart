import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'place_details.dart';
import 'models.dart';

class PlacesList extends StatefulWidget {
  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  List<dynamic> data = [];
  String _searchQuery = 'Югорский Государственный Университет';
  String _searchCity = 'Ханты-Мансийск';
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    fetchData();
  }

  fetchData() async {
    http.Response response;
    String selectedTypesString = _selectedTypes.join(',');
    try {
      if (selectedTypesString.isEmpty) {
        response = await http.get(Uri.parse(
            'https://catalog.api.2gis.com/3.0/items?q=$_searchQuery+ +$_searchCity&locale=ru_RU&key=65e4bd75-4737-4cd2-847d-8cf338389932'));
      } else {
        response = await http.get(Uri.parse(
            'https://catalog.api.2gis.com/3.0/items?q=$_searchQuery+ +$_searchCity&type=$selectedTypesString&locale=ru_RU&key=65e4bd75-4737-4cd2-847d-8cf338389932'));
      }
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body)['result']['items'] ?? [];
        });
      }
    } catch (e) {
      setState(() {
        data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Справочник мест'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: Text('Поиск'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  _searchQuery = value;
                                },
                                decoration: InputDecoration(hintText: 'Введите запрос'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  _searchCity = value;
                                },
                                decoration: InputDecoration(hintText: 'Город'),
                              ),
                              SizedBox(
                                height: 200.0, // give it a specific height
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: availableTypes
                                        .map((type) {
                                          // Фильтруем исключенные типы
                                          if (_shouldIncludeType(type)) {
                                            return CheckboxListTile(
                                              title: Text(_translateType(type)), // переводим тип на русский
                                              value: _selectedTypes.contains(type),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value!) {
                                                    _selectedTypes.add(type);
                                                  } else {
                                                    _selectedTypes.remove(type);
                                                  }
                                                });
                                              },
                                            );
                                          } else {
                                            return SizedBox.shrink(); // Прячем исключенные типы
                                          }
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, _searchQuery);
                              _setSearchQuery(_searchQuery);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              if (query != null) {
                _setSearchQuery(query);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // add padding to the container
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Name: ${data[index]['name'] ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Address: ${data[index]['address_name'] ?? ''}'),
                      onTap: () {
                        if (data[index]['id'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetail(placeId: data[index]['id']),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translateType(String type) {
    switch (type) {
      case 'building':
        return 'Здание';
      case 'street':
        return 'Улица';
      case 'station':
        return 'Станция';
      case 'attraction':
        return 'Достопримечательность';
      case 'adm_div.country':
        return 'Страна';
      case 'adm_div.region':
        return 'Регион';
      case 'adm_div.city':
        return 'Город';
      case 'adm_div.district':
        return 'Район';
      default:
        return type;
    }
  }

  bool _shouldIncludeType(String type) {
    // Проверяем, что тип не в списке исключенных
    List<String> excludedTypes = [
      'milestone',
      'living_area',
      'unit',
      'adm_div.locality',
      'crossroad',
      'platform',
      'entrance',
      'parking',
      'department',
      'settlement',
      'place',
      'route',
      'gate',
      'coordinates',
      'district',
      'road',
      'metro'
    ];
    return !excludedTypes.contains(type);
  }
}
