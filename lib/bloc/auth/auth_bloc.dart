import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../services/token_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TokenService tokenService;

  AuthBloc({required this.authRepository, required this.tokenService}) : super(AuthInitial()) {
    
    // Proses saat tombol Login ditekan
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.login(event.email, event.password);
        
        if (response['success'] == true) {
          // Menyimpan token ke memori HP
          await tokenService.saveTokenAndName(
            response['token'], 
            response['nama'] ?? 'User'
          );
          
          emit(AuthAuthenticated());
        } else {
          // PERBAIKAN 1: Menambahkan kata "message:"
          emit(AuthError(message: response['message'] ?? 'Login gagal. Cek email/password.'));
        }
      } catch (e) {
        // PERBAIKAN 2: Menambahkan kata "message:"
        emit(AuthError(message: 'Gagal menyambung ke server.'));
      }
    });

    // Proses saat tombol Logout ditekan
    on<LogoutButtonPressed>((event, emit) async {
      emit(AuthLoading());
      await tokenService.removeToken(); 
      // PERBAIKAN 3: Diganti menjadi AuthInitial()
      emit(AuthInitial());
    });
  }
}