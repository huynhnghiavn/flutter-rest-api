# Sử dụng bản dart ổn định nhất
FROM dart:stable AS build

# Tạo thư mục làm việc
WORKDIR /app

# Chỉ copy file cấu hình trước
COPY pubspec.yaml ./
# Nếu bạn có file lock, hãy copy nó, nếu không thì bỏ qua dòng dưới
COPY pubspec.lock* ./

# Tải các thư viện (Nếu lỗi 69, lệnh này sẽ cho biết thiếu file gì)
RUN dart pub get

# Sau đó mới copy toàn bộ nguồn
COPY . .

# Đảm bảo lệnh lấy thư viện cuối cùng để đồng bộ mã nguồn
RUN dart pub get --offline

# Build ra file thực thi
RUN dart compile exe lib/server.dart -o lib/server

# Chạy trên môi trường runtime nhỏ gọn
FROM debian:bookworm-slim
COPY --from=build /runtime/ /
COPY --from=build /app/lib/server /app/lib/server

EXPOSE 8080
CMD ["/app/lib/server"]
