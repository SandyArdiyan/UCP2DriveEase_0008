import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../services/token_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TokenService tokenService;

  AuthBloc({required this.authRepository, required this.tokenService}) : super(AuthInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutButtonPressed>((event, emit) async {await tokenService.removeToken();
      await tokenService.removeToken();
      emit(AuthInitial());
    });
  }
}