import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

import 'package:coalam_app/GlobalParamaters.dart';

class Recipe {
  final int id;
  final String title;
  final String chef;

  Recipe({
    this.id,
    this.title,
    this.chef,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      chef: json['chef'],
    );
  }
}

Future<List<Recipe>> fetchAllRecipes() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/all'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = jsonDecode(response.body);
    List<Recipe> listRecipes =
        List<Recipe>.from(l.map((model) => Recipe.fromJson(model)));
    return listRecipes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load recipes');
  }
}

class RecipesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: fetchAllRecipes(),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
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
    return Container(
      child: Center(
          child: Row(children: [
        Image.network(
          'https://coalam-backend.herokuapp.com/get_image/' +
              id.toString() +
              '/1',
          height: 100,
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
