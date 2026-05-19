import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    this.images = const [],
    this.brand,
    this.category,
    this.rating,
    this.stock,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String? brand;
  final String? category;
  final double? rating;
  final int? stock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'thumbnail': thumbnail,
        'images': images,
        'brand': brand,
        'category': category,
        'rating': rating,
        'stock': stock,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        thumbnail,
        images,
        brand,
        category,
        rating,
        stock,
      ];
}
