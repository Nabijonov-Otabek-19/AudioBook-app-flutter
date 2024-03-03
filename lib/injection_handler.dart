import 'package:audiobook_app/feature/data/datasource/local_data_source.dart';
import 'package:audiobook_app/feature/data/datasource/remote_data_source.dart';
import 'package:audiobook_app/feature/data/repository/repository_impl.dart';
import 'package:audiobook_app/feature/domain/usecase/get_audiofiles_usecase.dart';
import 'package:audiobook_app/feature/domain/usecase/get_books_usecase.dart';
import 'package:audiobook_app/feature/domain/usecase/get_top_books_usecase.dart';
import 'package:audiobook_app/feature/presentation/screen/book_detail/bloc/book_detail_bloc.dart';
import 'package:audiobook_app/feature/presentation/screen/home/bloc/home_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/base_api.dart';

final GetIt di = GetIt.instance;

Future<void> setupDI() async {
  // BaseApi
  di.registerLazySingleton<BaseApi>(() => BaseApi());

  //Dio
  di.registerLazySingleton<Dio>(() => di.get<BaseApi>().dio);

  // Data sources
  di.registerLazySingleton(() => RemoteDataSourceImpl(dio: di()));
  di.registerLazySingleton(() => DatabaseHelperImpl());

  // Repository
  di.registerLazySingleton<RepositoryImpl>(
    () => RepositoryImpl(remoteDataSource: di(), localDataSource: di()),
  );

  // UseCase
  di.registerLazySingleton(() => GetTopBooksUseCase(repository: di()));
  //di.registerLazySingleton(() => GetBooksUseCase(repository: di()));
  di.registerLazySingleton(() => GetAudioFilesUseCase(repository: di()));

  // Bloc
  di.registerLazySingleton(() => HomeBloc(
        getTopBooksUseCase: di(),
        //getBooksUseCase: di(),
        repository: di(),
      ));

  di.registerLazySingleton(() => BookDetailBloc(
        getAudioFilesUseCase: di(),
      ));
}
