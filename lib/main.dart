import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/api_repository.dart';
import 'repositories/auth_repository.dart'; 
import 'services/token_service.dart'; 
import 'bloc/katalog/katalog_bloc.dart';
import 'bloc/katalog/katalog_event.dart';
import 'bloc/auth/auth_bloc.dart'; 
import 'screens/auth/login_screen.dart';

// 1. UBAH main() MENJADI async
void main() async {
  // 2. TAMBAHKAN MANTRA INI WAJIB!
  WidgetsFlutterBinding.ensureInitialized(); 

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
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
            tokenService: TokenService(), 
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