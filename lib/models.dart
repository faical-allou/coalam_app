import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

class Recipe {
  final Map<String, dynamic> details;
  final int id;
  final String name;
  final int chefId;

  Recipe({this.details,this.id,this.name,this.chefId});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      details: json,
      id: json['id'],
      name: json['recipeName'],
      chefId: json['chefId'],
    );
  }
}

class Chef {
  final Map<String, dynamic> details;
  final int chefId;
  final String name;
  final String description;

  Chef({this.details,this.chefId,this.name,this.description});

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      details: json,
      chefId: json['chefId'],
      name: json['chefName'],
      description: json['chefDescription']
    );
  }
}



Future<List<Recipe>> fetchAllRecipes() async {
  final response = await http.get(Uri.parse(globals.endpoint+'/all'),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );

  if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Recipe> listRecipes =
      List<Recipe>.from(l.map((model) => Recipe.fromJson(model)));
      return listRecipes;
  }
  else {
      throw Exception('Failed to load recipes');
  }
}

Future<Recipe> fetchRecipe(id) async {
  final response =
  await http.get(Uri.parse(globals.endpoint+'/recipe/' + id.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Recipe> listRecipes =  List<Recipe>.from(l.map((model) => Recipe.fromJson(model)));
      return listRecipes[0];
  }
  else {
    throw Exception('Failed to load recipes');
  }
}

Future<Chef> fetchChef(id) async {
  final response =
  await http.get(Uri.parse(globals.endpoint+'/chef/' + id.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Chef> listChefs = List<Chef>.from(l.map((model) => Chef.fromJson(model)));
      return listChefs[0];
  }
  else {
    throw Exception('Failed to load chef');
  }
}

void deleteRecipe(id) async {
  final response =
     await  http.get(Uri.parse(globals.endpoint+'/delete_recipe/' + id.toString()),
       headers: {HttpHeaders.authorizationHeader: globals.appKey,},
     );
  if (response.statusCode == 200) {
  }
  else {
    throw Exception('Failed to delete');
  }
}

void deleteChef(id) async {
  final response =
  await  http.get(Uri.parse(globals.endpoint+'/delete_chef/' + id.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
  }
  else {
    throw Exception('Failed to delete');
  }
}



Future<int> getCountPictures(id) async {
  final response =
    await http.get(Uri.parse(globals.endpoint+'/get_image/' + id.toString() + '/count'),
      headers: {HttpHeaders.authorizationHeader: globals.appKey,},
    );
  if (response.statusCode == 200) {
      final count = jsonDecode(response.body);
      return count['data'];
  }
  else {
    throw Exception('Failed to load recipes');
  }
}

Future<List<dynamic>> getNextEvents(chefId,id) async {
  final response =
   await http.get(Uri.parse(globals.endpoint+'/get_schedule/' + chefId.toString() + '/'+id.toString()),
     headers: {HttpHeaders.authorizationHeader: globals.appKey,},
   );
  if (response.statusCode == 200) {
      final output = jsonDecode(response.body);
      return output['items'];
  }
  else {
    throw Exception('Failed to load recipes');
  }
}

asyncRecipeUpload(
    int recipeId,
    String recipeName,
    String recipeDescription,
    String ingredients,
    String tools,
    int chefId,
    File file
    ) async{
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(globals.endpoint+"/edit_recipe/"),);
  request.headers.addAll({HttpHeaders.authorizationHeader: globals.appKey});
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
}

asyncChefAccountUpload(
    String chefName,
    String chefDescription,
    int chefId,
    File file
    ) async {
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(globals.endpoint+"/edit_account/"),);
  request.headers.addAll({HttpHeaders.authorizationHeader: globals.appKey});
  //add text fields

  request.fields["chefName"] = chefName;
  request.fields["chefDescription"] = chefDescription;
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
  return responseString;
}

imageFetcher(String imageLinkToFetch, double h){
  return Image.network(
    globals.endpoint + imageLinkToFetch,
    height: h,
    headers: {'connection': 'Keep-Alive'},
  );
}