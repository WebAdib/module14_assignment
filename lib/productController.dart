import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Urls/urls.dart';

class ProductController {
  final List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  /// Fetch products from API
  Future<void> fetchProducts() async {
    final url = Uri.parse(Urls.readProduct);

    try {
      final response = await http.get(url);
      debugPrint("API Response Status: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success" && data["data"] is List) {
          _products.clear();
          _products.addAll(List<Map<String, dynamic>>.from(data["data"]));
        } else {
          debugPrint("Unexpected API Response Format: $data");
        }
      } else {
        throw Exception(
            "Failed to load products, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }
  }

  /// Create a new product by sending a POST request
  Future<void> createProduct(Map<String, dynamic> product) async {
    final url =
        Uri.parse(Urls.createProduct); // Replace with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(product),
      );

      debugPrint("Create Product Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          _products.add(product); // Add locally after a successful API response
        } else {
          debugPrint("Failed to add product: ${data["message"]}");
        }
      } else {
        throw Exception(
            "Failed to create product, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Error creating product: $error");
    }
  }

  /// Call API to create product and update UI
  Future<void> addProduct(Map<String, dynamic> product) async {
    await createProduct(product);
  }

  /// Delete product locally (API deletion can be added if needed)
  void deleteProduct(int index) {
    _products.removeAt(index);
  }
}
