import 'package:postgres/postgres.dart';


final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'postgres',
  username: 'postgres',
  password: 'Post@123!',
);


Future openDb() async {
  if (connection.isClosed) {
    await connection.open();
  }
}