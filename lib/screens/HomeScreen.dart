import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';


import 'package:coalam_app/GlobalParamaters.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          TextButton(
            child: Text("What's cooking  ? "),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/list',
              );
            },
          ),
          TextButton(
            child: Text("add a recipe"),
            onPressed: () {
              var listRecipes = context.read<GlobalState>();
              listRecipes.addRecipe();
            },
          ),
        ]),
      ),
    );
  }
}
