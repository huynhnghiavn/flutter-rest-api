import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'database.dart';

class SanPhamRouter{
  Router get router {
    final router = Router();

    // 🔹 Thêm sản phẩm
    router.post('/add', (Request request) async {
      final payload = jsonDecode(await request.readAsString());

      await openDb();
      await connection.query(
        'INSERT INTO tblsanpham(ten, dvt, mota) VALUES (@ten, @dvt, @mota)',
        substitutionValues: payload,
      );

      return Response.ok(
        jsonEncode({'message': 'Added successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 🔹 Lấy danh sách sản phẩm
    router.get('/list', (Request request) async {
      try{
        //1. Đảm bào DB mở
        if(connection.isClosed == true)
          await openDb();
        final result = await connection.query('SELECT * FROM tblsanpham');

        final data = result.map((row) => {
          'id': row[0],
          'ten': row[1],
          'dvt': row[2],
          'mota': row.length > 3 ? row[3] : '',
        }).toList();

        return Response.ok(
          jsonEncode(data),
          headers: {'Content-Type': 'application/json'},
        );
      }catch(e){
        print('Error: $e');
        return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    // 🔹 Xóa sản phẩm
    router.delete('/delete/<id>', (Request request, String id) async {
      await openDb();
      await connection.query(
        'DELETE FROM tblsanpham WHERE id = @id',
        substitutionValues: {'id': int.parse(id)},
      );

      return Response.ok(
        jsonEncode({'message': 'Deleted'}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // 🔹 Tìm kiếm sản phẩm theo tên
    router.get('/search/<keyword>', (Request request, String keyword) async {
      await openDb();
      final result = await connection.query(
        'SELECT * FROM tblsanpham WHERE ten ILIKE @kw',
        substitutionValues: {'kw': '%$keyword%'},
      );

      final data = result.map((row) => {
        'id': row[0],
        'ten': row[1],
        'dvt': row[2],
        'mota': row[3],
      }).toList();

      return Response.ok(
        jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
