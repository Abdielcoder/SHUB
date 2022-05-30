import 'dart:convert';

Batch batchFromJson(String str) => Batch.fromJson(json.decode(str));

String batchToJson(Batch data) => json.encode(data.toJson());

class Batch{

  String ID;
  String batch_number;
  String number_of_station;
  String line1;
  String fecha;
  String hora;
  List<Batch> toList = [];

  Batch({
    this.ID,
    this.batch_number,
    this.number_of_station,
    this.line1,
    this.fecha,
    this.hora,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    ID: json["ID"] is int ? json["ID"].toString() : json['ID'],
    batch_number: json["batch_number"] is int ? json["batch_number"].toString() : json['batch_number'],
    number_of_station: json["number_of_station"] is int ? json["number_of_station"].toString() : json['number_of_station'],
    line1: json["line1"],
    fecha: json["fecha"],
    hora: json["hora"],
  );

  Batch.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Batch batch = Batch.fromJson(item);
      toList.add(batch);
    });
  }

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "batch_number": batch_number,
    "number_of_station": number_of_station,
    "line1": line1,
    "fecha": fecha,
    "hora": hora,
  };
}