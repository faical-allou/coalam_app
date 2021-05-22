import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coalam_app/screens/HomeScreen.dart';
import 'package:coalam_app/screens/RecipeDetailsScreen.dart';
import 'package:coalam_app/screens/RecipesListScreen.dart';


import 'package:coalam_app/GlobalParamaters.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => GlobalState(),
      child: MyApp(),
    ),
  );
}
class GlobalState with ChangeNotifier {

  List<Map<String, String>> recipes = [
    {'title': 'Classic Burger', 'cook': 'Faical Allou'},
    {'title': 'BBQ Burger', 'cook': 'also Faical Allou'},
    {'title': 'Couscous', 'cook': "Faical's Mom"},
    {'title': 'Tajine', 'cook': "Faical's Mom"},
  ];

  void increment() {
    notifyListeners();
  }
  void addRecipe(){
    recipes.add({'title': 'Added Manually', 'cook': "pressing a button"});
    notifyListeners();
  }
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