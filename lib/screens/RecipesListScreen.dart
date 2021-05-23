import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

import 'package:coalam_app/GlobalParameters.dart';
import 'package:coalam_app/models.dart';

class RecipesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: fetchAllRecipes(),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                child: Column(
                  children: [
                    for (var i = 0; i <= snapshot.data.length - 1; i += 1)
                      RecipeElement(snapshot.data[i], i + 1)
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class RecipeElement extends StatelessWidget {
  final Recipe recipe;
  final int id;

  RecipeElement(this.recipe, this.id);



  @override
  Widget build(BuildContext context) {
    String title = recipe.title;
    String cook = recipe.chef;
    String tools = recipe.details['tools'];
    return Container(
      child: Center(
          child: Row(children: [
            Image.network(
              'http://10.0.2.2:5000/get_image/' +
                  id.toString() +
                  '/1',
              height: 100,
              headers: {'connection': 'Keep-Alive'},
            ),
        TextButton(
          child: Text('View Details stuff for $title'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/details/' + id.toString(),
            );
          },
        ),
      ])),
    );
  }
}
