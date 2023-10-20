import 'package:postgres/postgres.dart';

class Database {
  late PostgreSQLConnection connection;

  Future<PostgreSQLConnection> createConnection() async {
    connection = PostgreSQLConnection(
      "pg-petlink-petlink.aivencloud.com",
      19023,
      "defaultdb",
      username: "avnadmin",
      password: "AVNS_r9x866LM541U4Cit5EZ",
      useSSL: true,
    );
    await connection.open();
    return connection;
  }

  List<List<dynamic>> resultsUsers = [];

  Future<void> fetchAllUsers() async {
    try {
      final results = await connection.query('SELECT * FROM users');
      resultsUsers = results;
      print("Users retrieved successfully!");
    } catch (e) {
      print("Error: $e");
    }
  }
}
