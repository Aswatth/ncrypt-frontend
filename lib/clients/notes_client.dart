import 'package:Ncrypt/models/note.dart';
import 'package:Ncrypt/utils/system.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NotesClient {
  static final NotesClient _instance = NotesClient._internal();

  NotesClient._internal();

  factory NotesClient() {
    return _instance;
  }

  Future<dynamic> getAllNotes() async {
    var url = Uri.http("localhost:${System().PORT}", "/note");

    var response = await http.get(url,
        // headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"}
    );

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      if(data == null) {
        return null;
      }
      List<dynamic> noteList =
      data.map((json) => Note.fromJson(json)).toList();

      return noteList;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> getContent(String createdDateTime) async {
    var url = Uri.http("localhost:${System().PORT}", "/note/${createdDateTime}");

    var response = await http.get(url,
      // headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"}
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> addNote(Note note) async {
    var url = Uri.http("localhost:${System().PORT}", "/note");

    String requestBody = convert.jsonEncode(note.toJson());

    var response = await http.post(url,
        body: requestBody
      // headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"}
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> updateNote(String createdDateTime, Note updatedNote) async {
    var url = Uri.http("localhost:${System().PORT}", "/note/${createdDateTime}");

    String requestBody = convert.jsonEncode(updatedNote.toJson());

    var response = await http.put(url,
      body: requestBody
      // headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"}
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }

  Future<dynamic> deleteNote(String createdDateTime, Note updatedNote) async {
    var url = Uri.http("localhost:${System().PORT}", "/note/${createdDateTime}");

    var response = await http.delete(url,
      // headers: {"Authorization": "Bearer ${SystemDataClient().jwtToken}"}
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      var json = convert.jsonDecode(response.body);
      return json;
    }
  }
}