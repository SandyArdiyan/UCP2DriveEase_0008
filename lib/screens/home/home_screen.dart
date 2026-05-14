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
  String _userName = "Pengguna"; // Nama default sebelum data ditarik

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Tarik nama saat layar pertama kali dibuka
  }

  // Fungsi mengambil nama dari memory HP
  void _loadUserName() async {
    final name = await TokenService().getName();
    if (name != null && name.isNotEmpty) {
      setState(() {
        _userName = name;
      });
    }
  }

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
        // PERSONALIASASI BERANDA (Menyapa Nama User)
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Katalog DriveEase', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Selamat Datang, $_userName!', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        ),
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
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
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
                context.read<KatalogBloc>().add(FetchKatalog(query: value));
              },
            ),
          ),
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
                          title: Text(item.namaArmada, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Plat: ${item.platNomor} | Kategori: ${item.idKategori}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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