import 'package:audio_service/audio_service.dart';
import 'package:audiobook_app/feature/presentation/screen/book_detail/bloc/book_detail_bloc.dart';
import 'package:audiobook_app/feature/presentation/screen/home/bloc/home_bloc.dart';
import 'package:audiobook_app/feature/presentation/screen/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/helper/audio_helper.dart';
import 'injection_handler.dart';

late AudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDI();

  audioHandler = await initAudioService();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
                size: 100,
              ),
              Text(
                kDebugMode
                    ? errorDetails.exceptionAsString()
                    : "Oops... something went wrong",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const MyAudioBookApp());
}

class MyAudioBookApp extends StatefulWidget {
  const MyAudioBookApp({super.key});

  @override
  State<MyAudioBookApp> createState() => _MyAudioBookAppState();
}

class _MyAudioBookAppState extends State<MyAudioBookApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => di.get<HomeBloc>(),
        ),
        BlocProvider<BookDetailBloc>(
          create: (context) => di.get<BookDetailBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'AudioBook app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
