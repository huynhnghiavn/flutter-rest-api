class SanPham {
  int? id;
  String ten;
  String dvt;
  String mota;


  SanPham({this.id, required this.ten, required this.dvt, required this.mota});


  factory SanPham.fromJson(Map<String, dynamic> json) => SanPham(
    id: json['id'],
    ten: json['ten'],
    dvt: json['dvt'],
    mota: json['mota'],
  );


  Map<String, String> toJson() => {
    'ten': ten,
    'dvt': dvt,
    'mota': mota,
  };
}