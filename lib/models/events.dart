import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import '../globals.dart' as globals;

Future<List<dynamic>?> getNextEvents(chefId,id) async {
  final response =
  await http.get(Uri.parse(globals.endpoint+'/get_schedule/' + chefId.toString() + '/'+id.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
    final output = jsonDecode(response.body);
    return output['items'];
  }
  else {
    throw Exception('Failed to load events');
  }
}

createEvent(int? chefId, int recipeId, String start, String end, String description, Function updateScreen) async {
  var request = http.MultipartRequest("POST", Uri.parse(
      globals.endpoint + "/add_event/" + chefId.toString() + "/" +
          recipeId.toString()),);
  request.headers.addAll({HttpHeaders.authorizationHeader: globals.appKey});
  request.fields["eventStart"] = start;
  request.fields["eventEnd"] = end;
  request.fields["eventDescription"] = description;
  var response = await request.send();

  //Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  if (response.statusCode == 200) {
    updateScreen(() {});
    return 'event created';
  }
  else {
    throw Exception('Failed to create event');
  }
}

deleteEvent(String eventId,  Function updateScreen ) async {
  final response =
  await http.get(Uri.parse(globals.endpoint+'/delete_event/' + eventId.toString()),
    headers: {HttpHeaders.authorizationHeader: globals.appKey,},
  );
  if (response.statusCode == 200) {
    updateScreen((){});
    return 'event deleted';
  }
  else {
    throw Exception('Failed to delete event');
  }
}

