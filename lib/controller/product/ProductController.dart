import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/service/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var productList = <Product>[].obs;
  var bestSellerProductList = <Product>[].obs;
  // This list observes the UI
  var subCategoryProductList = <Product>[].obs;
  // This list keeps the original data for filtering
  List<Product> _originalSubCategoryList = [];

  // Sort Options
  var currentSortOption = 'Relevance'.obs;
  var currentSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsByBestSeller();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final productService = ProductService();
      final products = await productService.getProducts();
      productList.value = products;
      subCategoryProductList.value = products;
      _originalSubCategoryList = List.from(products);
      currentSortOption.value = 'Relevance';
      currentSearchQuery.value = '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsByBestSeller() async {
    try {
      isLoading.value = true;
      final productService = ProductService();
      final products = await productService.getProductsByBestSeller();
      bestSellerProductList.value = products;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products by best seller',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsBySubCategory(int subCategoryId) async {
    try {
      isLoading.value = true;
      final productService = ProductService();
      final products =
          await productService.getProductsBySubCategory(subCategoryId);
      subCategoryProductList.value = products;
      _originalSubCategoryList = List.from(products); // Backup original list
      currentSortOption.value = 'Relevance'; // Reset sort
      currentSearchQuery.value = ''; // Reset search query
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products by sub category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsByQuery(String query) async {
    try {
      isLoading.value = true;
      currentSearchQuery.value = query; // Update current query
      final productService = ProductService();
      final products = await productService.getProductsByQuery(query);
      subCategoryProductList.value = products;
      _originalSubCategoryList = List.from(products);
      currentSortOption.value = 'Relevance';
    } catch (e) {
      Get.snackbar('Error', 'Failed to search products',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  // --- Sorting Logic ---
  void sortProducts(String sortOption) {
    currentSortOption.value = sortOption;
    List<Product> products = List.from(subCategoryProductList);
    switch (sortOption) {
      case 'Price -- Low to High':
        products.sort((a, b) =>
            _calculateSellingPrice(a).compareTo(_calculateSellingPrice(b)));
        break;
      case 'Price -- High to Low':
        products.sort((a, b) =>
            _calculateSellingPrice(b).compareTo(_calculateSellingPrice(a)));
        break;
      case 'Newest First':
        products.sort((a, b) => (b.id ?? 0)
            .compareTo(a.id ?? 0)); // Assuming ID correlates with newness
        break;
      default: // Relevance
        // Ideally reset to original order, but since we might be filtered, we'll just not sort further
        // or re-apply filter to original list if needed. For now, simple no-op or id sort.
        products.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    }
    subCategoryProductList.value = products;
  }

  double _calculateSellingPrice(Product product) {
    return product.mrp - (product.mrp * (product.discountPercentage / 100));
  }

  // --- Filter Logic ---
  void filterProducts({
    RangeValues? priceRange,
    List<String>? selectedBrands,
    double? minDiscount,
  }) {
    List<Product> filtered = List.from(_originalSubCategoryList);

    if (priceRange != null) {
      filtered = filtered.where((p) {
        double price = _calculateSellingPrice(p);
        return price >= priceRange.start && price <= priceRange.end;
      }).toList();
    }

    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      filtered =
          filtered.where((p) => selectedBrands.contains(p.brand)).toList();
    }

    if (minDiscount != null) {
      filtered =
          filtered.where((p) => p.discountPercentage >= minDiscount).toList();
    }

    subCategoryProductList.value = filtered;
    // Re-apply sort after filter
    sortProducts(currentSortOption.value);
  }

  // Helper to get available brands for filter UI
  List<String> getAvailableBrands() {
    return _originalSubCategoryList.map((p) => p.brand).toSet().toList();
  }

  // Helper to get max price for slider
  double getMaxPrice() {
    if (_originalSubCategoryList.isEmpty) return 10000;
    return _originalSubCategoryList
        .map((p) => _calculateSellingPrice(p))
        .reduce((a, b) => a > b ? a : b);
  }
}
