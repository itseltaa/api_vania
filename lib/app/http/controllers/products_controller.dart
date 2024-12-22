import 'dart:convert';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class ProductsController {
  // GET /products
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT prod_id, vend_id, prod_name, prod_price, prod_desc 
        FROM products
      ''');

      final products = results.map((row) {
        final prodDesc = row[4];

        final descAsString = prodDesc is Uint8List
            ? utf8.decode(prodDesc)
            : prodDesc?.toString();

        return {
          'prod_id': row[0],
          'vend_id': row[1],
          'prod_name': row[2],
          'prod_price': row[3],
          'prod_desc': descAsString ?? '',
        };
      }).toList();

      return Response.ok(
        jsonEncode(products),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching products: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Gagal mengambil product'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /products
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      if (payload.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Request body tidak boleh kosong'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final data = jsonDecode(payload);
      final conn = await DatabaseProvider.getConnection();

      await conn.query(
        '''INSERT INTO products (prod_id, vend_id, prod_name, prod_price, prod_desc) 
        VALUES (?, ?, ?, ?, ?)''',
        [
          data['prod_id'],
          data['vend_id'],
          data['prod_name'],
          data['prod_price'],
          data['prod_desc'],
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Product Berhasil dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating product: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Product Gagal dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /products/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      if (payload.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Request body cannot be empty'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final data = jsonDecode(payload);
      final conn = await DatabaseProvider.getConnection();

      final result = await conn.query(
        '''UPDATE products 
          SET vend_id = ?, prod_name = ?, prod_price = ?, prod_desc = ? 
          WHERE prod_id = ?''',
        [
          data['vend_id'],
          data['prod_name'],
          data['prod_price'],
          data['prod_desc'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response.notFound(
          jsonEncode({'error': 'Product tidak ditemukan'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'message': 'Product Berhasil di Updated '}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating product: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Product Gagal Dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // DELETE /products/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        'DELETE FROM products WHERE prod_id = ?',
        [id],
      );

      if (result.affectedRows == 0) {
        return Response.notFound(
          jsonEncode({'error': 'Product not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'message': 'Berhasil Membuat Product'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting product: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Gagal menghapus product'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
