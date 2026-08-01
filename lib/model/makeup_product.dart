class MakeupProduct {
  const MakeupProduct({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.imageLink,
    this.priceSign,
    this.currency,
    this.productLink = '',
    this.websiteLink = '',
    this.description = '',
    this.rating,
    this.category,
    this.productType,
    this.tagList = const [],
  });

  final int id;
  final String brand;
  final String name;
  final String price;
  final String? priceSign;
  final String? currency;
  final String imageLink;
  final String productLink;
  final String websiteLink;
  final String description;
  final double? rating;
  final String? category;
  final String? productType;
  final List<String> tagList;

  factory MakeupProduct.fromJson(Map<String, dynamic> json) {
    return MakeupProduct(
      id: json['id'] as int? ?? 0,
      brand: (json['brand'] as String?) ?? 'Unknown brand',
      name: (json['name'] as String?) ?? 'Unnamed product',
      price: (json['price'] as String?) ?? 'N/A',
      priceSign: json['price_sign'] as String?,
      currency: json['currency'] as String?,
      imageLink: (json['image_link'] as String?) ?? '',
      productLink: (json['product_link'] as String?) ?? '',
      websiteLink: (json['website_link'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      rating: json['rating'] == null ? null : (json['rating'] as num).toDouble(),
      category: json['category'] as String?,
      productType: json['product_type'] as String?,
      tagList: (json['tag_list'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          const [],
    );
  }
}
