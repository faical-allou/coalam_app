import 'package:flutter/material.dart';
import 'package:coalam_app/main.dart';
import 'package:provider/provider.dart';
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

Future<List<Recipe>> fetchRecipe(id) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:5000/' + id.toString()));

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

class RecipeDetailsScreen extends StatelessWidget {
  String id;

  RecipeDetailsScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: fetchRecipe(id),
        builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(('Viewing details for ' +
                          snapshot.data[0].title +
                          ' by ' +
                          snapshot.data[0].chef)),
                    ),
                    TextButton(
                      child: Text('back!'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
