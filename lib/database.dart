import 'dart:io';
import 'package:postgres/postgres.dart';

// 1. Lấy chuỗi kết nối từ biến môi trường của Render
// Nếu chạy ở máy (local) mà không có biến này, nó sẽ dùng giá trị mặc định sau dấu ??
final String dbUrl = Platform.environment['DATABASE_URL'] ?? 'postgres://postgres:Post@123!@localhost:5432/postgres';

// 2. Phân tách chuỗi URL
final uri = Uri.parse(dbUrl);
final username = uri.userInfo.contains(':') ? uri.userInfo.split(':').first : uri.userInfo;
final password = uri.userInfo.contains(':') ? uri.userInfo.split(':').last : null;

// 3. Khởi tạo connection với các thông số từ URL
final connection = PostgreSQLConnection(
  uri.host,
  uri.port,
  uri.pathSegments.first, // Đây là tên Database
  username: username,
  password: password,
  useSSL: true, // QUAN TRỌNG: Render bắt buộc phải có SSL để kết nối thành công
);

Future openDb() async {
  try {
    if (connection.isClosed) {
      await connection.open();
      print("Kết nối Database thành công!");
    }
  } catch (e) {
    print("Lỗi kết nối Database: $e");
  }
}
