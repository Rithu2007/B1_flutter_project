class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final int discount;
  final String unit;
  final String description;
  final double rating;
  final int reviewCount;
  final bool availability;
  final String image;
  final bool isPopular;
  final List<String> highlights;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.unit,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.availability,
    required this.image,
    this.isPopular = false,
    this.highlights = const [
      'Fresh product',
      'Quality checked',
      'Local supplier',
      'Fast delivery',
    ],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'unit': unit,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'availability': availability,
      'image': image,
      'isPopular': isPopular,
      'highlights': highlights,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      originalPrice: (map['originalPrice'] as num).toDouble(),
      discount: (map['discount'] as num).toInt(),
      unit: map['unit'] as String,
      description: map['description'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewCount: (map['reviewCount'] as num).toInt(),
      availability: map['availability'] as bool? ?? true,
      image: map['image'] as String,
      isPopular: map['isPopular'] as bool? ?? false,
      highlights: (map['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            'Fresh product',
            'Quality checked',
            'Local supplier',
            'Fast delivery',
          ],
    );
  }
}
