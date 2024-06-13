import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'places_screen.dart';
import 'favorites.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  late SharedPreferences prefs;
  late List<FavoritePlaces> favoritePlaces = [];

  void onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
    initSharedPreferences();
    if (index == 1) {
      await initSharedPreferences();
    }
  }
  
  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    favoritePlaces = (prefs.getStringList('favoritePlaces') ?? [])
        .map((jsonString) => FavoritePlaces.fromMap(json.decode(jsonString)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Справочник путешественника',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', 'RU'), // Добавляет русский язык
      ],
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            PlacesList(),
            FavoritesTab(favoritePlaces: favoritePlaces),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite), 
              label: 'Избранное',
            ),
          ],
        ),
      ),
    );
  }
}

