import 'dart:convert';
import 'package:http/http.dart' show Client;

import 'package:audiobook_app/core/utils/constants.dart';
import 'package:audiobook_app/feature/data/model/audiofile_model.dart';
import 'package:dio/dio.dart';

import '../model/book_model.dart';

abstract class RemoteDataSource {
  Future<List<BookModel>> fetchBooks(int offset, int limit);

  Future<List<AudioFileModel>> fetchAudioFiles(String? bookId);

  Future<List<BookModel>> fetchTopBooks();
}

const books =
    "https://archive.org/advancedsearch.php?q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size&sort[]=addeddate%20desc&output=json&rows=20&page=1";

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  Client client = Client();

  RemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookModel>> fetchBooks(int offset, int limit) async {
    try {
      final response = await client.get(
        Uri.parse(books
            //"${Endpoints.latestBooksApi}&rows=$limit&page=${offset / limit + 1}",
            ),
      );

      Map resJson = json.decode(response.body);
      final model = BookModel.fromJsonArray(resJson['response']['docs']);

      return model;

      /*final Response response = await dio.get(
        "${Endpoints.latestBooksApi}&rows=$limit&page=${offset / limit + 1}",
      );

      Map resJson = await json.decode(response.data);
      print("DATASOURCE = FETCHBOOKS AFTER");

      return BookModel.fromJsonArray(resJson['response']['docs']);*/
    } catch (e) {
      print("DATASOURCE BOOKS ERROR = $e");
      throw Exception(e);
    }
  }

  @override
  Future<List<AudioFileModel>> fetchAudioFiles(String? bookId) async {
    try {
      final response =
          await client.get(Uri.parse("${Endpoints.metadata}/$bookId/files"));
      Map resJson = json.decode(response.body);

      List<AudioFileModel> aFiles = [];
      resJson["result"].forEach((item) {
        if (item["source"] == "original" && item["track"] != null) {
          item["book_id"] = bookId;
          aFiles.add(AudioFileModel.fromJson(item));
        }
      });

      return aFiles;
    } catch (e) {
      print("DATASOURCE AUDIOS ERROR = $e");
      throw Exception(e);
    }
  }

  @override
  Future<List<BookModel>> fetchTopBooks() async {
    try {
      final response = await client.get(Uri.parse(Endpoints.mostDownloaded));
      Map resJson = json.decode(response.body);
      final model = BookModel.fromJsonArray(resJson['response']['docs']);

      return model;
    } catch (e) {
      print("DATASOURCE TOPBOOKS ERROR = $e");
      throw Exception(e);
    }
  }
}
