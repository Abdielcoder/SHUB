


import 'dart:convert';

Car categoryFromJson(String str) => Car.fromJson(json.decode(str));

String categoryToJson(Car data) => json.encode(data.toJson());

class Car{

  String id;
  String id_user;
  String marca;
  String modelo;
  String year;
  String placa;
  String color;
  String image;
  List<Car> toList = [];

  Car({
    this.id,
    this.id_user,
    this.marca,
    this.modelo,
    this.year,
    this.placa,
    this.color,
    this.image,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    id: json["id"] is int ? json["id"].toString() : json['id'],
    id_user: json["id_user"] is int ? json["id_user"].toString() : json['id_user'],
    marca: json["marca"],
    modelo: json["modelo"],
    year: json["year"],
    placa: json["placa"],
    color: json["color"],
    image: json["image"],
  );

  Car.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Car category = Car.fromJson(item);
      toList.add(category);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user": id_user,
    "marca": marca,
    "modelo": modelo,
    "year": year,
    "placa": placa,
    "color": color,
    "image": image
  };
}