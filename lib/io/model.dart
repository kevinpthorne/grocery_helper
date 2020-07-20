import 'dart:convert';

import 'package:uuid/uuid.dart';

abstract class Model {
  String id;
  DateTime dateCreated;
  DateTime dateLastModified;
  String extra;

  Model({this.id, this.extra, this.dateCreated, this.dateLastModified}) {
    this.id = this.id ?? Uuid().v4();
    this.dateCreated = this.dateCreated ?? new DateTime.now();
    this.dateLastModified = dateLastModified ?? new DateTime.now();
    this.extra = this.extra ?? '{}';
  }

  Model.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateCreated = DateTime.parse(json['dateCreated']),
        dateLastModified = DateTime.parse(json['dateLastModified']),
        extra = json['extra'];

  void setExtra(String key, dynamic value) {
    Map<String, dynamic> json = jsonDecode(this.extra);
    json[key] = value;
    this.extra = jsonEncode(json);
  }

  void removeExtra(String key) {
    Map<String, dynamic> json = jsonDecode(this.extra);
    json.remove(key);
    this.extra = jsonEncode(json);
  }

  dynamic getExtra(String key) {
    Map<String, dynamic> json = jsonDecode(this.extra);
    return json[key];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'id': this.id,
      'dateCreated': this.dateCreated.toIso8601String(),
      'dateLastModified': this.dateLastModified.toIso8601String(),
      'extra': this.extra,
    };
    result.addAll(this.moreToJson());
    return result;
  }

  // TODO rename this. Gross.
  Map<String, dynamic> moreToJson();

}
