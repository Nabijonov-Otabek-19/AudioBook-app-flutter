import 'package:audiobook_app/core/utils/loading_state_enum.dart';
import 'package:audiobook_app/feature/presentation/widget/book_item_widget.dart';
import 'package:audiobook_app/feature/presentation/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_handler.dart';
import '../../../data/model/book_model.dart';
import '../../widget/book_grid_item_widget.dart';
import '../../widget/bottom_loader_widget.dart';
import '../book_detail/book_detail_screen.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    di.get<HomeBloc>().add(GetBooksEvent());
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.books.isEmpty) {
            return const LoadingWidget();
          }
          print("HOMESCREEN BOOKS NOT EMPTY");
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverAppBar(
                title: Text("Books"),
                floating: true,
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Most Downloaded",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BookGridItem(
                        book: state.top[index],
                        onTap: () => _openDetail(context, state.top[index]),
                      );
                    },
                    childCount: state.top.length,
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Recent Books",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final books = state.books;
                      if (index >= books.length) {
                        return const BottomLoader();
                      } else {
                        return BookItem(
                          context: context,
                          book: books[index],
                          onOpenDetailTap: () =>
                              _openDetail(context, books[index]),
                        );
                      }
                    },
                    childCount: state.hasReachedMax
                        ? state.books.length
                        : state.books.length + 1,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      di.get<HomeBloc>().add(GetBooksEvent());
    }
  }

  void _openDetail(BuildContext context, BookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
    );
  }
}
