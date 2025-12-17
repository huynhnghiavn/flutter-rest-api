import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import '../lib/sanpham_router.dart';


void main() async {
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(SanPhamRouter().router);


  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Server running on port ${server.port}');
}
