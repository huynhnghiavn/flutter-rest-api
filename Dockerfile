FROM dart:stable AS build

WORKDIR /app

# Copy file cấu hình
COPY pubspec.yaml ./
# Xóa bỏ lệnh copy pubspec.lock nếu nó đang gây lỗi, hoặc cứ để nếu bạn đã chạy pub get ở local
COPY pubspec.lock* ./

# Tải các thư viện (Lúc này sẽ không còn đòi Flutter SDK nữa)
RUN dart pub get

# Copy toàn bộ mã nguồn
COPY . .

# Biên dịch (Sửa lại đường dẫn bin/server.dart nếu file của bạn nằm chỗ khác)
RUN dart compile exe bin/server.dart -o bin/server

# Stage chạy ứng dụng
FROM debian:bookworm-slim
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8080
CMD ["/app/bin/server"]
