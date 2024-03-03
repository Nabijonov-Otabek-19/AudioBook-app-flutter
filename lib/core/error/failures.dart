import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String errorMessage;

  const Failure({required this.errorMessage});

  @override
  List<Object> get props => [];
}