class CoffeeDataModel {
  List<Coffee>? coffee;

  CoffeeDataModel({this.coffee});

  CoffeeDataModel.fromJson(List<dynamic> json) {
    if (json != null) {
      coffee = <Coffee>[];
      json.forEach((v) {
        coffee!.add(new Coffee.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coffee != null) {
      data['coffee'] = this.coffee!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coffee {
  int? id;
  String? title;
  String? description;
  List<String>? ingredients;
  String? image;

  Coffee({
    this.id,
    this.title,
    this.description,
    this.ingredients,
    this.image,
  });

  Coffee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    ingredients = List<String>.from(json['ingredients']);
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['ingredients'] = this.ingredients;
    data['image'] = this.image;
    return data;
  }
}
