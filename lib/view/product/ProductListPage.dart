import 'package:e_commerce_app/controller/CartController.dart';
import 'package:e_commerce_app/controller/product/ProductController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';

import 'package:e_commerce_app/widget/home/ProductCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final productController = Get.find<ProductController>();
    _searchController =
        TextEditingController(text: productController.currentSearchQuery.value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final productController = Get.find<ProductController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          automaticallyImplyLeading: false, // Custom leading
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon:
                    Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () => Get.back(),
              ),
              Expanded(
                child: Container(
                  height: size.height * 0.05,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: theme.colorScheme.onSurface.withOpacity(0.0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (query) {
                      productController.fetchProductsByQuery(query);
                    },
                    style: GoogleFonts.roboto(
                        color: theme.colorScheme.onSurface, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Search for products",
                      hintStyle: GoogleFonts.roboto(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14),
                      prefixIcon: Icon(Icons.search,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: 20),
                      suffixIcon: Obx(() {
                        // Listen to currentSearchQuery to toggle clear icon
                        return productController
                                .currentSearchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    size: 18,
                                    color: theme.colorScheme.onSurface),
                                onPressed: () {
                                  _searchController.clear();
                                  productController.fetchProductsByQuery('');
                                },
                              )
                            : const SizedBox.shrink();
                      }),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.cartPage);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(() {
                    final cartController = Get.put(CartController());
                    return Badge(
                      label: Text('${cartController.totalItems}'),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        body: Column(
          children: [
            // Sort and Filter Strip
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showSortBottomSheet(theme, context, productController);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort,
                              size: 18, color: theme.colorScheme.onSurface),
                          const SizedBox(width: 6),
                          Text("Sort",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface)),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.grey[300]),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _showFilterBottomSheet(
                            theme, context, productController);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list,
                              size: 18, color: theme.colorScheme.onSurface),
                          const SizedBox(width: 6),
                          Text("Filter",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1), // Divider
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productController.subCategoryProductList.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 60, color: theme.colorScheme.onSurface),
                      const SizedBox(height: 10),
                      Text("No products found",
                          style: GoogleFonts.roboto(
                              color: theme.colorScheme.onSurface)),
                    ],
                  ));
                }
                return GridView.builder(
                    padding: const EdgeInsets.only(top: 2),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.57,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemCount: productController.subCategoryProductList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                          product:
                              productController.subCategoryProductList[index]);
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(
      ThemeData theme, BuildContext context, ProductController controller) {
    Get.bottomSheet(
      Container(
        color: theme.colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Sort By",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ...[
              "Relevance",
              "Price -- Low to High",
              "Price -- High to Low",
              "Newest First"
            ]
                .map((option) => Obx(() => RadioListTile(
                      title: Text(option, style: GoogleFonts.roboto()),
                      value: option,
                      groupValue: controller.currentSortOption.value,
                      onChanged: (value) {
                        controller.sortProducts(value.toString());
                        Get.back();
                      },
                      activeColor: theme.colorScheme.primary,
                    )))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
      ThemeData theme, BuildContext context, ProductController controller) {
    // State for local filter inputs (to avoid applying until 'Apply' is clicked)
    final Rx<RangeValues> priceRange =
        RangeValues(0, controller.getMaxPrice()).obs;
    final Rx<double> minDiscount = 0.0.obs;
    final List<String> availableBrands = controller.getAvailableBrands();
    final RxList<String> selectedBrands = <String>[].obs;

    Get.bottomSheet(
      Container(
        color: theme.colorScheme.surface,
        height: MediaQuery.of(context).size.height * 0.7, // Taller sheet
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filters",
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        // Clear filters
                        controller.sortProducts("Relevance");
                        controller.filterProducts();
                        Get.back();
                      },
                      child: Text("Clear",
                          style: GoogleFonts.roboto(
                              color: theme.colorScheme.primary)))
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price Range",
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                    Obx(() => RangeSlider(
                          values: priceRange.value,
                          min: 0,
                          max: controller.getMaxPrice(),
                          divisions: 20,
                          labels: RangeLabels(
                            "₹${priceRange.value.start.round()}",
                            "₹${priceRange.value.end.round()}",
                          ),
                          onChanged: (values) {
                            priceRange.value = values;
                          },
                        )),
                    const SizedBox(height: 20),
                    Text("Min Discount",
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                    Obx(() => Slider(
                          value: minDiscount.value,
                          min: 0,
                          max: 80, // Cap at 80% reasonable
                          divisions: 8,
                          label: "${minDiscount.value.round()}%",
                          onChanged: (value) {
                            minDiscount.value = value;
                          },
                        )),
                    const SizedBox(height: 20),
                    if (availableBrands.isNotEmpty) ...[
                      Text("Brand",
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: availableBrands.map((brand) {
                          return Obx(() => FilterChip(
                                label: Text(brand),
                                selected: selectedBrands.contains(brand),
                                onSelected: (bool selected) {
                                  if (selected) {
                                    selectedBrands.add(brand);
                                  } else {
                                    selectedBrands.remove(brand);
                                  }
                                },
                              ));
                        }).toList(),
                      )
                    ]
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    controller.filterProducts(
                      priceRange: priceRange.value,
                      selectedBrands: selectedBrands,
                      minDiscount: minDiscount.value,
                    );
                    Get.back();
                  },
                  child: Text("Apply Filters",
                      style: GoogleFonts.roboto(
                          color: theme.colorScheme.onPrimary, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allow full height
    );
  }
}
