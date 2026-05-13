import 'package:equatable/equatable.dart';
import '../../models/kategori_model.dart';

abstract class KategoriState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<KategoriModel> data;

  KategoriLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class KategoriError extends KategoriState {
  final String message;

  KategoriError({required this.message});

  @override
  List<Object?> get props => [message];
}