import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class CustomersController {
  // GET /customers
  static Future<Response> getAll(Request request) async {
    try {
      // Query semua kolom dari tabel customers
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT 
          cust_id, cust_name, cust_address, cust_city, 
          cust_state, cust_zip, cust_country, cust_tel 
        FROM customers
      ''');

      // Map hasil query ke dalam JSON lengkap
      final customers = results
          .map((row) => {
                'cust_id': row[0],
                'cust_name': row[1],
                'cust_address': row[2],
                'cust_city': row[3],
                'cust_state': row[4],
                'cust_zip': row[5],
                'cust_country': row[6],
                'cust_tel': row[7],
              })
          .toList();

      // Mengembalikan JSON lengkap
      return Response.ok(
        jsonEncode(customers),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching customers: $e');

      // Fallback: Kembalikan data dummy
      final customersDummy = [
        {
          'cust_id': 'T001',
          'cust_name': 'Lesti Okta',
          'cust_address': '12 jl Babarsari',
          'cust_city': 'Yogyakarta',
          'cust_state': 'DIY',
          'cust_zip': '10012',
          'cust_country': 'Indonesia',
          'cust_tel': '082261831968'
        },
      ];
      return Response.ok(
        jsonEncode(customersDummy),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /customers
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // Validasi semua kolom
      if (data['cust_id'] == null ||
          data['cust_name'] == null ||
          data['cust_address'] == null ||
          data['cust_city'] == null ||
          data['cust_state'] == null ||
          data['cust_zip'] == null ||
          data['cust_country'] == null ||
          data['cust_tel'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();

      // Query INSERT untuk semua kolom
      await conn.query(
        '''
        INSERT INTO customers (cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_tel)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          data['cust_id'],
          data['cust_name'],
          data['cust_address'],
          data['cust_city'],
          data['cust_state'],
          data['cust_zip'],
          data['cust_country'],
          data['cust_tel']
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Customer berhasil dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'customer gagal dibuat'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /customers/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // Validasi semua kolom yang akan diupdate
      if (data['cust_name'] == null ||
          data['cust_address'] == null ||
          data['cust_city'] == null ||
          data['cust_state'] == null ||
          data['cust_zip'] == null ||
          data['cust_country'] == null ||
          data['cust_tel'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();

      // Query UPDATE untuk memperbarui data
      final result = await conn.query(
        '''
        UPDATE customers 
        SET cust_name = ?, cust_address = ?, cust_city = ?, cust_state = ?, cust_zip = ?, cust_country = ?, cust_tel = ?
        WHERE cust_id = ?
        ''',
        [
          data['cust_name'],
          data['cust_address'],
          data['cust_city'],
          data['cust_state'],
          data['cust_zip'],
          data['cust_country'],
          data['cust_tel'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Customer not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Customer berhasil diupdated'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'customer gagal di updated'}),
      );
    }
  }

  // DELETE /customers/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();

      // Query DELETE untuk menghapus data
      final result =
          await conn.query('DELETE FROM customers WHERE cust_id = ?', [id]);

      if (result.affectedRows == 0) {
        return Response(404,
            body: jsonEncode({'error': 'Customer tidak ditemukan'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Customer berhasl di deleted'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting customer: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'customer gagal di deleted'}),
      );
    }
  }
}
