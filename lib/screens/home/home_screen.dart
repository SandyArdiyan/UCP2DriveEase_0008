import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/katalog/katalog_bloc.dart';
import '../../bloc/katalog/katalog_event.dart';
import '../../bloc/katalog/katalog_state.dart';
import '../../services/token_service.dart';
import '../auth/login_screen.dart';
import 'form_katalog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Fungsi Logout: Hapus token dari HP dan kembali ke halaman Login
  void _logout() async {
    await TokenService().removeToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog DriveEase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<KatalogBloc>().add(FetchKatalog());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout, // Memanggil fungsi logout di atas
          ),
        ],
      ),
      body: Column(
        children: [
          // KOTAK PENCARIAN (Fitur Search)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama armada atau plat...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<KatalogBloc>().add(FetchKatalog());
                  },
                ),
              ),
              onChanged: (value) {
                // Memanggil Node.js setiap kali user mengetik
                context.read<KatalogBloc>().add(FetchKatalog(query: value));
              },
            ),
          ),

          // DAFTAR ARMADA
          Expanded(
            child: BlocBuilder<KatalogBloc, KatalogState>(
              builder: (context, state) {
                if (state is KatalogLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is KatalogError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                } else if (state is KatalogLoaded) {
                  final list = state.katalogList;

                  if (list.isEmpty) {
                    return const Center(child: Text('Data tidak ditemukan.'));
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade50,
                            child: const Icon(Icons.directions_car, color: Colors.deepPurple),
                          ),
                          title: Text(
                            item.namaArmada, 
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          subtitle: Text('Plat: ${item.platNomor} | ID Kategori: ${item.idKategori}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Edit
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormKatalogScreen(
                                        initialData: {
                                          'id': item.id,
                                          'nama_armada': item.namaArmada,
                                          'plat_nomor': item.platNomor,
                                          'id_kategori': item.idKategori,
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Tombol Hapus
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context.read<KatalogBloc>().add(DeleteKatalog(id: item.id));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade100,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormKatalogScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.deepPurple),
      ),
    );
  }
}