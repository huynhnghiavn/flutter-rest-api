FROM dart:stable AS build

WORKDIR /app

# 1. Copy cấu hình và tải thư viện
COPY pubspec.* ./
RUN dart pub get

# 2. Copy toàn bộ dự án (bao gồm cả thư mục lib và bin)
COPY . .

# 3. Biên dịch file chính trong thư mục bin
RUN dart compile exe bin/server.dart -o bin/server

# Stage 2: Runtime
FROM debian:bookworm-slim
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8080
CMD ["/app/bin/server"]
