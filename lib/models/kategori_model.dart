class KategoriModel {
  final int id;
  final String namaKategori;

  KategoriModel({
    required this.id, 
    required this.namaKategori,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      namaKategori: json['nama_kategori'], // Pastikan nama key ini sama persis dengan response JSON dari Node.js
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
    };
  }
}