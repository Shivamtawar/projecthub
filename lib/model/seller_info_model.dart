class Seller {
  final int id;
  final String name;
  final String? image;

  Seller({
    required this.id,
    required this.name,
    this.image,
  });

  // From JSON
  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'],
      image: json['image'], // Will be null if no image is present
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image, // Will be null if no image
    };
  }
}
