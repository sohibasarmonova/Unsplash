import 'package:flutter/material.dart';
import 'package:unsplash/pages/collection_photos.dart';
import 'package:unsplash/pages/collections_page.dart';
import 'package:unsplash/pages/details_page.dart';
import 'package:unsplash/pages/home_page.dart';
import 'package:unsplash/pages/search_page.dart';
import 'package:unsplash/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        HomePage.id: (context) => const HomePage(),
        SearchPage.id: (context) => const SearchPage(),
        CollectionPage.id: (context) => const CollectionPage(),
        CollectionPhotosPage.id: (context) => const CollectionPhotosPage(),
        DetailsPage.id: (context) => DetailsPage(),
      },
      home: SplashPage(),
    );
  }
}

