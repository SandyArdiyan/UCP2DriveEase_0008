import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/katalog/katalog_bloc.dart';
import '../../bloc/katalog/katalog_event.dart';
import '../../bloc/katalog/katalog_state.dart';
import '../shared/custom_button.dart';
import '../shared/custom_input.dart';

class FormKatalogScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Untuk Edit Data

  const FormKatalogScreen({super.key, this.initialData});

  @override
  State<FormKatalogScreen> createState() => _FormKatalogScreenState();
}

class _FormKatalogScreenState extends State<FormKatalogScreen> {
  final _namaController = TextEditingController();
  final _platController = TextEditingController();
  
  // Variabel baru untuk menampung ID dari pilihan Dropdown
  int? _selectedKategoriId;

  // Daftar kategori buatan (Bisa disesuaikan dengan isi tabel kategorimu di MySQL)
  final List<Map<String, dynamic>> _kategoriList = [
    {'id': 1, 'nama': '1 - Minibus (Avanza, Xenia)'},
    {'id': 2, 'nama': '2 - City Car (Brio, Agya)'},
    {'id': 3, 'nama': '3 - SUV (Pajero, Fortuner)'},
  ];

  @override
  void initState() {
    super.initState();
    // Jika Mode Edit, isi kolom dan dropdown dengan data sebelumnya
    if (widget.initialData != null) {
      _namaController.text = widget.initialData!['nama_armada'] ?? '';
      _platController.text = widget.initialData!['plat_nomor'] ?? '';
      
      // Ambil ID Kategori sebelumnya, pastikan tipenya int
      var kategoriId = widget.initialData!['id_kategori'];
      if (kategoriId != null) {
        // Cek apakah id tersebut ada di dalam list dummy kita
        bool exists = _kategoriList.any((k) => k['id'] == kategoriId);
        if (exists) {
          _selectedKategoriId = kategoriId is int ? kategoriId : int.parse(kategoriId.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData == null ? 'Tambah Armada' : 'Edit Armada'),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context); // Kembali jika berhasil
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInput(controller: _namaController, label: 'Nama Armada'),
              const SizedBox(height: 16),
              CustomInput(controller: _platController, label: 'Plat Nomor'),
              const SizedBox(height: 16),
              
              // INI DIA: Kolom Dropdown Keren Pengganti Ketikan Manual
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Pilih Kategori Armada',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                initialValue: _selectedKategoriId,
                hint: const Text('Ketuk untuk memilih...'),
                items: _kategoriList.map((kategori) {
                  return DropdownMenuItem<int>(
                    value: kategori['id'], // Menyimpan Angka ID-nya (1, 2, atau 3)
                    child: Text(kategori['nama']), // Menampilkan Teksnya ke User
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategoriId = value;
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              BlocBuilder<KatalogBloc, KatalogState>(
                builder: (context, state) {
                  if (state is KatalogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    text: 'SIMPAN DATA',
                    onPressed: () {
                      // Validasi: Cegah simpan jika ada yang kosong atau dropdown belum dipilih
                      if (_namaController.text.isEmpty || 
                          _platController.text.isEmpty || 
                          _selectedKategoriId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua kolom & Kategori wajib diisi!'), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      // Bungkus data untuk dikirim
                      final dataKatalog = {
                        'nama_armada': _namaController.text.trim(),
                        'id_kategori': _selectedKategoriId, // Otomatis mengirim angka integer
                        'plat_nomor': _platController.text.trim(),
                      };

                      if (widget.initialData == null) {
                        context.read<KatalogBloc>().add(AddKatalog(data: dataKatalog));
                      } else {
                        int id = widget.initialData!['id']; 
                        context.read<KatalogBloc>().add(UpdateKatalog(id: id, data: dataKatalog));
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}