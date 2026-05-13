import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
import 'kategori_event.dart';
import 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final ApiRepository apiRepository;

  KategoriBloc({required this.apiRepository}) : super(KategoriInitial()) {
    on<FetchKategori>(_onFetchKategori);
    on<AddKategori>(_onAddKategori);
    on<UpdateKategori>(_onUpdateKategori);
    on<DeleteKategori>(_onDeleteKategori);
  }

  Future<void> _onFetchKategori(FetchKategori event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    try {
      final data = await apiRepository.getKategori();
      emit(KategoriLoaded(data: data));
    } catch (e) {
      emit(KategoriError(message: e.toString()));
    }
  }

  Future<void> _onAddKategori(AddKategori event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    try {
      await apiRepository.createKategori(event.data);
      add(FetchKategori()); // Refresh data
    } catch (e) {
      emit(KategoriError(message: e.toString()));
    }
  }

  Future<void> _onUpdateKategori(UpdateKategori event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    try {
      await apiRepository.updateKategori(event.id, event.data);
      add(FetchKategori()); // Refresh data
    } catch (e) {
      emit(KategoriError(message: e.toString()));
    }
  }

  Future<void> _onDeleteKategori(DeleteKategori event, Emitter<KategoriState> emit) async {
    emit(KategoriLoading());
    try {
      await apiRepository.deleteKategori(event.id);
      add(FetchKategori()); // Refresh data
    } catch (e) {
      emit(KategoriError(message: e.toString()));
    }
  }
}