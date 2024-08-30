// To parse this JSON data, do final engineModel = engineModelFromJson(jsonString);

import 'dart:convert';

EngineModel engineModelFromJson(String str) =>
    EngineModel.fromJson(json.decode(str));

String engineModelToJson(EngineModel data) => json.encode(data.toJson());

class EngineModel {
  String? id;
  String? userId;
  String? name;
  String? imageUrl;
  String? subname;
  bool? isGenerator;
  bool? isCompressor;

  EngineModel({
    this.id,
    this.userId,
    this.name,
    this.imageUrl,
    this.subname,
    this.isGenerator,
    this.isCompressor,
  });

  factory EngineModel.fromJson(Map<String, dynamic> json) => EngineModel(
        id: json["_id"],
        userId: json[" user"],
        name: json["name"],
        imageUrl: json["url"],
        subname: json["subname"],
        isGenerator: json["is_generator"],
        isCompressor: json["is_compressor"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": userId,
        "name": name,
        "subname": subname,
        "is_generator": isGenerator,
        "is_compressor": isCompressor,
      };
}
