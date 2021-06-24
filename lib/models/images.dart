import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import '../globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

imageFetcher(String imageLinkToFetch, double h){
  return Image.network(
    globals.endpoint + imageLinkToFetch,
    height: h,
    headers: {'connection': 'Keep-Alive'},
  );
}

Future<int?> getCountPictures(id) async {
  final response =
  await http.get(Uri.parse(globals.endpoint+'/get_image/' + id.toString() + '/count'),
    //headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
    final count = jsonDecode(response.body);
    return count['data'];
  }
  else {
    throw Exception('Failed to load count');
  }
}
