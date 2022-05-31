import 'dart:convert';

ConsultaBatch batchFromJson(String str) => ConsultaBatch.fromJson(json.decode(str));

String batchToJson(ConsultaBatch data) => json.encode(data.toJson());

class ConsultaBatch{
  String ID;
  String station;
  String number_station;
  String console_group;
  String cg_barcode;
  String bd_total_line_count;
  List<ConsultaBatch> toList = [];

  ConsultaBatch({
    this.ID,
    this.station,
    this.number_station,
    this.console_group,
    this.cg_barcode,
    this.bd_total_line_count,
  });

  factory ConsultaBatch.fromJson(Map<String, dynamic> json) => ConsultaBatch(
    ID: json["ID"] is int ? json["ID"].toString() : json['ID'],
    station: json["station"] is int ? json["station"].toString() : json['station'],
    number_station: json["number_station"] is int ? json["number_station"].toString() : json['number_station'],
    console_group: json["console_group"],
    cg_barcode: json["cg_barcode"],
    bd_total_line_count: json["bd_total_line_count"],
  );

  ConsultaBatch.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      ConsultaBatch batch = ConsultaBatch.fromJson(item);
      toList.add(batch);
    });
  }

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "station": station,
    "number_station": number_station,
    "console_group": console_group,
    "cg_barcode": cg_barcode,
    "bd_total_line_count": bd_total_line_count,
  };
}