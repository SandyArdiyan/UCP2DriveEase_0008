import 'package:equatable/equatable.dart';

abstract class KategoriEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchKategori extends KategoriEvent {}

class AddKategori extends KategoriEvent {
  final Map<String, dynamic> data;

  AddKategori({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateKategori extends KategoriEvent {
  final int id;
  final Map<String, dynamic> data;

  UpdateKategori({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class DeleteKategori extends KategoriEvent {
  final int id;

  DeleteKategori({required this.id});

  @override
  List<Object?> get props => [id];
}