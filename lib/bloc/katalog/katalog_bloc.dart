import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/api_repository.dart';
import 'katalog_event.dart';
import 'katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final ApiRepository apiRepository;

  KatalogBloc({required this.apiRepository}) : super(KatalogInitial()) {
    on<FetchKatalog>(_onFetchKatalog);
    on<AddKatalog>(_onAddKatalog);
    on<UpdateKatalog>(_onUpdateKatalog);
    on<DeleteKatalog>(_onDeleteKatalog);
  }

  Future<void> _onFetchKatalog(FetchKatalog event, Emitter<KatalogState> emit) async {
    emit(KatalogLoading());
    try {
      // Mengirim keyword pencarian ke API
      final data = await apiRepository.getKatalog(query: event.query);
      emit(KatalogLoaded(data));
    } catch (e) {
      emit(KatalogError(e.toString()));
    }
  }

  Future<void> _onAddKatalog(AddKatalog event, Emitter<KatalogState> emit) async {
    emit(KatalogLoading());
    try {
      await apiRepository.createKatalog(event.data);
      emit(KatalogSuccess('Berhasil menambah armada!'));
      add(FetchKatalog()); // Refresh otomatis
    } catch (e) {
      emit(KatalogError(e.toString()));
    }
  }

  Future<void> _onUpdateKatalog(UpdateKatalog event, Emitter<KatalogState> emit) async {
    emit(KatalogLoading());
    try {
      await apiRepository.updateKatalog(event.id, event.data);
      emit(KatalogSuccess('Berhasil mengubah data armada!'));
      add(FetchKatalog()); // Refresh otomatis
    } catch (e) {
      emit(KatalogError(e.toString()));
    }
  }

  Future<void> _onDeleteKatalog(DeleteKatalog event, Emitter<KatalogState> emit) async {
    emit(KatalogLoading());
    try {
      await apiRepository.deleteKatalog(event.id);
      emit(KatalogSuccess('Armada berhasil dihapus!'));
      add(FetchKatalog()); // Refresh otomatis
    } catch (e) {
      emit(KatalogError(e.toString()));
    }
  }
}