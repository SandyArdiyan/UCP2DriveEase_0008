import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/api_repository.dart';
import 'repositories/auth_repository.dart'; 
import 'services/token_service.dart'; // <-- 1. WAJIB IMPORT INI
import 'bloc/katalog/katalog_bloc.dart';
import 'bloc/katalog/katalog_event.dart';
import 'bloc/auth/auth_bloc.dart'; 
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const DriveEaseApp());
}

class DriveEaseApp extends StatelessWidget {
  const DriveEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KatalogBloc>(
          create: (context) => KatalogBloc(apiRepository: ApiRepository())..add(FetchKatalog()),
        ),
        BlocProvider<AuthBloc>(
          // 2. TAMBAHKAN TOKEN SERVICE DI SINI
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
            tokenService: TokenService(), // <-- Pemicu error-nya ada di sini tadi
          ),
        ),
      ],
      child: MaterialApp(
        title: 'DriveEase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LoginScreen(), 
      ),
    );
  }
}