import 'package:dio/dio.dart';

class BaseApi {
  final _dio = Dio(
    BaseOptions(
      validateStatus: (status) => true,
    ),
  );

  Dio get dio => _dio;
}
