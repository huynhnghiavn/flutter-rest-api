CREATE TABLE tblsanpham (
	id SERIAL PRIMARY KEY,
	ten TEXT,
	dvt TEXT,
	mota TEXT
);
go
CREATE TABLE donhang (
	id SERIAL PRIMARY KEY,
	ngay DATE,
	tongtien NUMERIC,
	loai TEXT
);
go
CREATE TABLE chitietdonhang (
	id SERIAL PRIMARY KEY,
	donhang_id INT REFERENCES donhang(id),
	sanpham_id INT REFERENCES sanpham(id),
	gia NUMERIC,
	soluong INT
);