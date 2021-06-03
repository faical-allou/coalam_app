import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

class Recipe {
  final Map<String, dynamic> details;
  final int id;
  final String name;
  final String chef;
  final int chefId;

  Recipe({
    this.details,
    this.id,
    this.name,
    this.chef,
    this.chefId,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      details: json,
      id: json['id'],
      name: json['recipeName'],
      chef: json['chefName'],
      chefId: json['chefId'],
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

Future<Recipe> fetchRecipe(id) async {
  final response =
  await http.get(Uri.parse('http://10.0.2.2:5000/' + id.toString()));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = jsonDecode(response.body);
    List<Recipe> listRecipes =
    List<Recipe>.from(l.map((model) => Recipe.fromJson(model)));
    return listRecipes[0];
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

Future<List<dynamic>> getNextEvents(chefId,id) async {
  final response =
   await http.get(Uri.parse('http://10.0.2.2:5000/get_schedule/' + chefId.toString() + '/'+id.toString()));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final output = jsonDecode(response.body);
    return output['items'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load recipes');
  }
}

asyncFileUpload(
    int recipeId,
    String recipeName,
    String recipeDescription,
    String ingredients,
    String tools,
    int chefId,
    File file
    ) async{
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse("http://10.0.2.2:5000/edit_recipe/"));
  //add text fields

  request.fields["recipeId"] = recipeId.toString();
  request.fields["recipeName"] = recipeName;
  request.fields["recipeDescription"] = recipeDescription;
  request.fields["ingredients"] = ingredients;
  request.fields["tools"] = tools;
  request.fields["chefId"] = chefId.toString();

  //create multipart using filepath, string or bytes
  if (file != null) {
    var pic = await http.MultipartFile.fromPath("image1", file.path);
    //add multipart to request
    request.files.add(pic);
  }
  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
}
