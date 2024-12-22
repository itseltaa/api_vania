import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:dotenv/dotenv.dart'; // Impor pustaka dotenv
import 'package:lestiterakhir/route/api_route.dart';
import 'package:lestiterakhir/database/migrations/migrate.dart';

void main() async {
  // Muat file .env
  final dotenv = DotEnv()..load();

  // Jalankan migrasi database
  print('Running database migrations...');
  await runMigrations();

  // Konfigurasi server
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(apiRouter());

  final server = await serve(
    handler,
    'localhost',
    int.parse(dotenv['APP_PORT'] ??
        '8000'), // Gunakan instance dotenv untuk mengakses variabel
  );
  print('Server running at http://localhost:${server.port}');
}
