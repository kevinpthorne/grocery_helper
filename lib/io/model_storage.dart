import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'model.dart';

abstract class ModelStorage<T extends Model> {
  Future<T> read(String id);

  Future<Map<String, T>> readAll();

  Future write(T model);

  Future destroy(String id);

  List<T> convert(Map<String, T> results) {
    List<T> newList = [];
    results.forEach((key, value) {
      newList.add(value);
    });
    return newList;
  }
}

abstract class JsonFileStorage<T extends Model> extends ModelStorage<T> {
  String get localFileName;

  T buildModel(Map<String, dynamic> data);

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    final name = localFileName;
    return File('$path/$name');
  }

  Future<Map<String, dynamic>> readFile() async {
    final file = await localFile;

    //Checks for no file
    if (!file.existsSync()) {
      await file.create();
    }

    String contents = await file.readAsString();

    if (contents == '') {
      contents = '{}';
    }

    return await jsonDecode(contents);
  }

  Future writeFile(Map<String, dynamic> data) async {
    final file = await localFile;
    await file.writeAsString(jsonEncode(data));
  }

  @override
  Future<Map<String, T>> readAll() async {
    Map<String, dynamic> raw = await this.readFile();
    Map<String, T> result = {};
    raw.forEach(
            (String id, dynamic data) => result[id] = this.buildModel(data));

    return result ?? <String, T>{};
  }

  @override
  Future<T> read(String id) async {
    Map<String, dynamic> raw = await this.readFile();
    return this.buildModel(raw[id]);
  }

  @override
  Future write(T model) async {
    model.dateLastModified = new DateTime.now();

    Map<String, dynamic> raw = await this.readFile();
    raw[model.id] = model.toJson();
    this.writeFile(raw);
  }

  @override
  Future destroy(String id) async {
    Map<String, dynamic> raw = await this.readFile();
    raw.remove(id);
    this.writeFile(raw);
  }
}
