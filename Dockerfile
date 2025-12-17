# Bước 1: Build ứng dụng
FROM dart:stable AS build

WORKDIR /app

# Copy các file cấu hình thư viện trước để tận dụng cache
COPY pubspec.* .
RUN dart pub get

# Copy toàn bộ mã nguồn và build ra file thực thi
COPY . .
RUN dart compile exe lib/server.dart -o lib/server

# Bước 2: Tạo image nhỏ gọn để chạy
FROM subfuzion/dart:slim

# Copy file đã build từ bước 1 sang
COPY --from=build /lib/server /lib/server

# Mở cổng 8080 (hoặc bất kỳ cổng nào bạn dùng)
EXPOSE 8080

# Chạy server
CMD ["/lib/server"]
