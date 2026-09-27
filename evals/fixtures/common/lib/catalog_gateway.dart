/// Transport seam for the host application and deterministic tests.
abstract interface class CatalogGateway {
  Future<List<Map<String, dynamic>>> search(String query);
  Future<Map<String, dynamic>> get(String id);
}
