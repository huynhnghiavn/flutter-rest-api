# Giai đoạn 1: Build (Biên dịch code)
FROM dart:stable AS build

WORKDIR /app

# 1. Copy cấu hình và tải thư viện
COPY pubspec.* ./
RUN dart pub get

# 2. Copy toàn bộ mã nguồn
COPY . .

# 3. Biên dịch file server.dart thành file thực thi nhị phân
RUN dart compile exe bin/server.dart -o bin/server

# Giai đoạn 2: Runtime (Chạy ứng dụng)
# Sử dụng chính image dart để tránh lỗi xung đột thư mục hệ thống /lib
FROM dart:stable

WORKDIR /app

# Copy file đã biên dịch từ giai đoạn build sang
COPY --from=build /app/bin/server /app/bin/server

# Cổng mặc định (Render sẽ tự map cổng này)
EXPOSE 8080

# Chạy server
CMD ["/app/bin/server"]
