import 'package:Ncrypt/models/attributes.dart';

class Note {
  late String createdDateTime;
  late String title;
  late String content;
  late Attributes attributes;

  Note(
      {required this.createdDateTime,
      required this.title,
      required this.content,
      required this.attributes});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      createdDateTime: json['created_date_time'],
      title: json['title'],
      content: json['content'],
      attributes: Attributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() => {
        'created_date_time': createdDateTime,
        'title': title,
        'attributes': attributes.toJson(),
        'content': content,
      };
}
