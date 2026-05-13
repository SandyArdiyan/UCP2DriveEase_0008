abstract class KatalogEvent {}

class FetchKatalog extends KatalogEvent {
  final String query;
  FetchKatalog({this.query = ''}); // Parameter untuk fitur Search
}

class AddKatalog extends KatalogEvent {
  final Map<String, dynamic> data;
  AddKatalog({required this.data});
}

class UpdateKatalog extends KatalogEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateKatalog({required this.id, required this.data});
}

class DeleteKatalog extends KatalogEvent {
  final int id;
  DeleteKatalog({required this.id});
}