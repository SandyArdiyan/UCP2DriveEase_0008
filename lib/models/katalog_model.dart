class KatalogModel {
  final int id;
  final String namaArmada;
  final int idKategori;
  final String platNomor;

  KatalogModel({required this.id, required this.namaArmada, required this.idKategori, required this.platNomor});

  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      id: json['id'],
      namaArmada: json['nama_armada'],
      idKategori: json['id_kategori'],
      platNomor: json['plat_nomor'],
    );
  }
}