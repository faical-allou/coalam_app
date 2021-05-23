import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coalam_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

import 'package:coalam_app/GlobalParameters.dart';


class Recipe {
  final Map<String, dynamic> details;
  final int id;
  final String title;
  final String chef;

  Recipe({
    this.details,
    this.id,
    this.title,
    this.chef,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      details: json,
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

Future<int> getCountPictures(id) async {
  final response =
    await http.get(Uri.parse('http://10.0.2.2:5000/get_image/' + id.toString() + '/count'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final count = jsonDecode(response.body);
    return count['data'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load recipes');
  }
}