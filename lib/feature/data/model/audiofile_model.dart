import 'dart:convert';

const String _base = "https://archive.org/download";

class AudioFileModel{
  final String? bookId;
  final String? title;
  final String? name;
  final String? url;
  final double? length;
  final int? track;
  final int? size;


  AudioFileModel.fromJson(Map json):
    bookId=json["book_id"],
    title=json["title"],
    name=json["name"],
    track=int.parse(json["track"].split("/")[0]),
    size=int.parse(json["size"]),
    length=double.parse(json["length"]),
    url="$_base/${json['book_id']}/${json['name']}";

  AudioFileModel.fromDB(Map json):
    bookId=json["book_id"],
    title=json["title"],
    name=json["name"],
    track=json["track"],
    size=json["size"],
    length=json["length"],
    url=json["url"];

  static List<AudioFileModel> fromJsonArray(List json) {
    List<AudioFileModel> audiofiles = <AudioFileModel>[];
    for (var audiofile in json) {
      audiofiles.add(AudioFileModel.fromJson(audiofile));
    }
    return audiofiles;
  }
  static List<AudioFileModel> fromDBArray(List json) {
    List<AudioFileModel> audiofiles = <AudioFileModel>[];
    for (var audiofile in json) {
      audiofiles.add(AudioFileModel.fromDB(audiofile));
    }
    return audiofiles;
  }

  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "book_id":bookId,
      "url":url,
      "title":title,
      "length":length,
      "track":track,
      "size":size
    };
  }

  static String toJsonArray(List<AudioFileModel> audiofiles){
    return json.encode(audiofiles.map((audiofile)=>audiofile.toMap()).toList());
  }

}