import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/makeup_product.dart';

abstract class MakeupProductDataSource {
  Future<List<MakeupProduct>> fetchProducts();
}

class MakeupRepository implements MakeupProductDataSource {
  MakeupRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _endpoint =
      'https://makeup-api.herokuapp.com/api/v1/products.json';

  @override
  Future<List<MakeupProduct>> fetchProducts() async {
    final response = await _client.get(Uri.parse(_endpoint));

    if (response.statusCode != 200) {
      throw Exception('Unable to load products (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected response format');
    }

    return decoded
        .map((item) => MakeupProduct.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
