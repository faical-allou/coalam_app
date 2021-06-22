import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import '../globals.dart' as globals;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

class Recipe {
  final Map<String, dynamic>? details;
  final int? id;
  final String? name;
  final int? chefId;

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
  final Map<String, dynamic>? details;
  final int? chefId;
  final String? gId;
  final String? name;
  final String? description;

  Chef({this.details,this.chefId,this.name,this.description, this.gId});

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      gId: json['gId'],
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
      throw Exception('Failed to load list of recipes');
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

Future<Chef> fetchChef(id, idType) async {
  String lookup;
  idType == 'coalam'
  ? lookup = '/chef/'
  : idType == 'google'
    ? lookup = '/gchef/'
    : throw Exception('wrong type');
  final response =
  await http.get(Uri.parse(globals.endpoint + lookup + id.toString()),
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

void deleteRecipe(id,function) async {
  final response =
     await  http.get(Uri.parse(globals.endpoint+'/delete_recipe/' + id.toString()),
       headers: {HttpHeaders.authorizationHeader: globals.appKey,},
     );
  if (response.statusCode == 200) {
  }
  else {
    throw Exception('Failed to delete recipe');
  }
}

void deleteChef(id, function) async {
  final response =
  await  http.get(Uri.parse(globals.endpoint+'/delete_chef/' + id.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
  }
  else {
    throw Exception('Failed to delete chef');
  }
}




asyncRecipeUpload(
    int? recipeId,
    String recipeName,
    String recipeDescription,
    String ingredients,
    String tools,
    int? chefId,
    String? filepath,
    Uint8List? bytes
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


  //var pic = await http.MultipartFile.fromPath("image1", filepath);
  var pic2 = http.MultipartFile.fromBytes('image1', bytes!, filename:'internalName', contentType: new MediaType('image', 'jpeg') );
  //add multipart to request
  request.files.add(pic2);

  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
}

asyncChefAccountUpload(
    String chefName,
    String chefDescription,
    int? chefId,
    String gId,
    File? file,
    Uint8List? bytes
    ) async {
  //create multipart request for POST or PATCH method
  var request = http.MultipartRequest("POST", Uri.parse(globals.endpoint+"/edit_account/"),);
  request.headers.addAll({HttpHeaders.authorizationHeader: globals.appKey});
  //add text fields
  request.fields["gId"] = gId;
  request.fields["chefName"] = chefName;
  request.fields["chefDescription"] = chefDescription;
  request.fields["chefId"] = chefId.toString();
  if (bytes != null) {
    //create multipart using filepath, string or bytes
    var pic2 = http.MultipartFile.fromBytes(
        'image1', bytes, filename: 'internalName',
        contentType: new MediaType('image', 'jpeg'));
    //add multipart to request
    request.files.add(pic2);
  }
  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  return responseString;
}
