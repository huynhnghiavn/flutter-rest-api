import 'dart:io';
import 'package:postgres/postgres.dart';

/// FIX: Không dùng connection global nữa
/// FIX: Mỗi lần gọi sẽ tạo connection MỚI
Future<PostgreSQLConnection> openDb() async {
  try {
    final dbUrl = Platform.environment['DATABASE_URL'];

    PostgreSQLConnection connection;

    if (dbUrl != null) {
      // ===== CHẠY TRÊN RENDER =====
      final uri = Uri.parse(dbUrl);

      final userInfo = uri.userInfo.split(':');

      connection = PostgreSQLConnection(
        uri.host,
        uri.port,
        uri.pathSegments.first, // tên database
        username: userInfo[0],
        password: userInfo[1],
        useSSL: true, // Render bắt buộc SSL
      );
    } else {
      // ===== CHẠY LOCAL =====
      connection = PostgreSQLConnection(
        'localhost',
        5432,
        'postgres',
        username: 'postgres',
        password: 'Post@123!', // giữ nguyên password local
      );
    }

    await connection.open();
    print('Kết nối Database thành công!');
    return connection;
  } catch (e) {
    print('Lỗi kết nối Database: $e');
    rethrow; // FIX: để router biết là DB lỗi
  }
}
