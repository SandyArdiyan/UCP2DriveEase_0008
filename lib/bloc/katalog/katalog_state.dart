import 'package:equatable/equatable.dart';
import '../../../models/katalog_model.dart';

abstract class KatalogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KatalogInitial extends KatalogState {}

// Status saat menunggu respons API (biasanya memunculkan loading spinner)
class KatalogLoading extends KatalogState {}

// Status saat data berhasil diambil dari MySQL lewat Node.js
class KatalogLoaded extends KatalogState {
  // SUDAH DIPERBAIKI: Mengubah 'data' menjadi 'katalogList' agar sinkron dengan home_screen
  final List<KatalogModel> katalogList;

  // Constructor dibuat tanpa 'required' dan 'named parameter' agar sinkron dengan katalog_bloc
  KatalogLoaded(this.katalogList);

  @override
  List<Object?> get props => [katalogList];
}

// WAJIB DITAMBAHKAN: Status saat proses tambah/ubah/hapus berhasil (untuk SnackBar)
class KatalogSuccess extends KatalogState {
  final String message;

  KatalogSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Status jika ada error (token tidak valid, koneksi putus, dsb)
class KatalogError extends KatalogState {
  final String message;

  KatalogError(this.message);

  @override
  List<Object?> get props => [message];
}