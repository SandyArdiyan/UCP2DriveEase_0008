import 'package:flutter/material.dart';

class DetailKatalog extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailKatalog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Armada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListTile(
            title: Text(data['nama_armada'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Plat Nomor: ${data['plat_nomor']}'),
                Text('Kategori ID: ${data['id_kategori']}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}