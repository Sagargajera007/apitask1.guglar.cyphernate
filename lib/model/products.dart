class Products {
  String? sId;
  String? name;
  String? description;
  List<String>? images;

  Products({this.sId, this.name, this.description, this.images});

  Products.fromJson(Map json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['images'] = this.images;
    return data;
  }
}