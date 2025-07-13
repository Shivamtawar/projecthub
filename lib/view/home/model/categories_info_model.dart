class CategoryModel {
  int? id;
  final String? image;
  final String? name;
  final String? color;

  // Constructor
  CategoryModel({this.id, this.image, this.name, this.color});

  // Factory constructor to create a CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["category_id"],
      image: json['image'] as String?,
      name: json['category_name'] as String?,
    );
  }

  // Method to convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      "category_id": id,
      'image': image,
      'name': name,
      'color': color,
    };
  }
}
