import 'package:flutter/material.dart';
import 'package:coalam_app/screens/HomeScreen.dart';
import 'package:coalam_app/screens/RecipeDetailsScreen.dart';
import 'package:coalam_app/screens/RecipesListScreen.dart';


import 'package:coalam_app/GlobalParamaters.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomeScreen());
        }
        var uri = Uri.parse(settings.name);
        // Handle '/details/:id'
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'details') {
          var id = uri.pathSegments[1];
          return MaterialPageRoute(builder: (context) => RecipeDetailsScreen(id: id));
        }
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments.first == 'list') {
          return MaterialPageRoute(builder: (context) => RecipesListScreen());
        }

        return MaterialPageRoute(builder: (context) => UnknownScreen());
      },
    );
  }
}





class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}