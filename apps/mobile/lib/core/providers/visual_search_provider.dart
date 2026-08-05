import 'dart:async';
import 'package:flutter/foundation.dart';

enum VisualSearchStatus { idle, scanning, analyzing, success, noMatch, error }

class MatchedProduct {
  final String id;
  final String name;
  final String brand;
  final String categoryName;
  final double price;
  final double mrp;
  final String unit;
  final String imageUrl;
  final double rating;
  final int deliveryEtaMins;
  final double confidencePercentage;
  final bool isAvailable;
  final int stock;

  MatchedProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryName,
    required this.price,
    required this.mrp,
    required this.unit,
    required this.imageUrl,
    required this.rating,
    required this.deliveryEtaMins,
    required this.confidencePercentage,
    required this.isAvailable,
    required this.stock,
  });
}

class ExtractedVisionMetadata {
  final String productName;
  final String brand;
  final String category;
  final String weight;
  final double mrp;
  final String variant;
  final String? barcode;
  final double confidenceScore;
  final String description;

  ExtractedVisionMetadata({
    required this.productName,
    required this.brand,
    required this.category,
    required this.weight,
    required this.mrp,
    required this.variant,
    this.barcode,
    required this.confidenceScore,
    required this.description,
  });
}

class VisualSearchProvider extends ChangeNotifier {
  VisualSearchStatus _status = VisualSearchStatus.idle;
  VisualSearchStatus get status => _status;

  String? _capturedImagePath;
  String? get capturedImagePath => _capturedImagePath;

  ExtractedVisionMetadata? _extractedMetadata;
  ExtractedVisionMetadata? get extractedMetadata => _extractedMetadata;

  List<MatchedProduct> _matchedProducts = [];
  List<MatchedProduct> get matchedProducts => _matchedProducts;

  List<MatchedProduct> _similarProducts = [];
  List<MatchedProduct> get similarProducts => _similarProducts;

  List<MatchedProduct> _sameBrandProducts = [];
  List<MatchedProduct> get sameBrandProducts => _sameBrandProducts;

  List<MatchedProduct> _sameCategoryProducts = [];
  List<MatchedProduct> get sameCategoryProducts => _sameCategoryProducts;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _flashOn = false;
  bool get flashOn => _flashOn;

  void toggleFlash() {
    _flashOn = !_flashOn;
    notifyListeners();
  }

  void reset() {
    _status = VisualSearchStatus.idle;
    _capturedImagePath = null;
    _extractedMetadata = null;
    _matchedProducts = [];
    _similarProducts = [];
    _sameBrandProducts = [];
    _sameCategoryProducts = [];
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> analyzeImage(String imagePath) async {
    _capturedImagePath = imagePath;
    _status = VisualSearchStatus.analyzing;
    _errorMessage = null;
    notifyListeners();

    // Fast AI Recognition simulation (< 2 seconds)
    await Future.delayed(const Duration(milliseconds: 1400));

    // Sample mock response matching backend vision specs
    _extractedMetadata = ExtractedVisionMetadata(
      productName: 'Aashirvaad Shuddh Chakki Atta',
      brand: 'Aashirvaad',
      category: 'Grocery',
      weight: '5 kg Bag',
      mrp: 299.0,
      variant: '5 kg',
      barcode: '8901058002102',
      confidenceScore: 97.8,
      description: '100% pure whole wheat grain flour with natural fiber & nutrients.',
    );

    _matchedProducts = [
      MatchedProduct(
        id: 'p_atta_5kg',
        name: 'Aashirvaad Shuddh Chakki Atta',
        brand: 'Aashirvaad',
        categoryName: 'Grocery',
        price: 265.0,
        mrp: 299.0,
        unit: '5 kg Bag',
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
        rating: 4.9,
        deliveryEtaMins: 10,
        confidencePercentage: 97.8,
        isAvailable: true,
        stock: 45,
      ),
      MatchedProduct(
        id: 'p_atta_10kg',
        name: 'Aashirvaad Shuddh Chakki Atta',
        brand: 'Aashirvaad',
        categoryName: 'Grocery',
        price: 420.0,
        mrp: 510.0,
        unit: '10 kg Bag',
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
        rating: 4.8,
        deliveryEtaMins: 10,
        confidencePercentage: 91.2,
        isAvailable: true,
        stock: 20,
      ),
    ];

    _similarProducts = [
      MatchedProduct(
        id: 'p_fortune_atta',
        name: 'Fortune Chakki Fresh Atta',
        brand: 'Fortune',
        categoryName: 'Grocery',
        price: 245.0,
        mrp: 280.0,
        unit: '5 kg Bag',
        imageUrl: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
        rating: 4.7,
        deliveryEtaMins: 10,
        confidencePercentage: 84.0,
        isAvailable: true,
        stock: 30,
      ),
      MatchedProduct(
        id: 'p_multigrain',
        name: 'Pillsbury Multigrain Atta',
        brand: 'Pillsbury',
        categoryName: 'Grocery',
        price: 285.0,
        mrp: 320.0,
        unit: '5 kg Bag',
        imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
        rating: 4.8,
        deliveryEtaMins: 10,
        confidencePercentage: 80.5,
        isAvailable: true,
        stock: 15,
      ),
    ];

    _sameBrandProducts = [
      MatchedProduct(
        id: 'p_aashirvaad_salt',
        name: 'Aashirvaad Iodiased Salt',
        brand: 'Aashirvaad',
        categoryName: 'Cooking Essentials',
        price: 28.0,
        mrp: 32.0,
        unit: '1 kg Pack',
        imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',
        rating: 4.9,
        deliveryEtaMins: 10,
        confidencePercentage: 75.0,
        isAvailable: true,
        stock: 100,
      ),
    ];

    _sameCategoryProducts = [
      MatchedProduct(
        id: 'p_basmati_rice',
        name: 'Fortune Everyday Basmati Rice',
        brand: 'Fortune',
        categoryName: 'Grocery',
        price: 499.0,
        mrp: 650.0,
        unit: '5 kg Pack',
        imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400',
        rating: 4.9,
        deliveryEtaMins: 10,
        confidencePercentage: 70.0,
        isAvailable: true,
        stock: 60,
      ),
    ];

    _status = VisualSearchStatus.success;
    notifyListeners();
  }

  Future<void> searchBarcode(String barcode) async {
    _status = VisualSearchStatus.analyzing;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    _extractedMetadata = ExtractedVisionMetadata(
      productName: 'Amul Taaza Toned Milk',
      brand: 'Amul',
      category: 'Dairy, Bread & Eggs',
      weight: '1 L Pouch',
      mrp: 56.0,
      variant: '1 L',
      barcode: barcode,
      confidenceScore: 99.9,
      description: 'Pasteurised toned milk with essential vitamins.',
    );

    _matchedProducts = [
      MatchedProduct(
        id: 'p_milk_1l',
        name: 'Amul Taaza Toned Fresh Milk',
        brand: 'Amul',
        categoryName: 'Dairy, Bread & Eggs',
        price: 54.0,
        mrp: 56.0,
        unit: '1 L Pouch',
        imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
        rating: 4.9,
        deliveryEtaMins: 10,
        confidencePercentage: 99.9,
        isAvailable: true,
        stock: 80,
      ),
    ];

    _status = VisualSearchStatus.success;
    notifyListeners();
  }
}
