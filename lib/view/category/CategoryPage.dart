import 'package:e_commerce_app/controller/category/CategoryController.dart';
import 'package:e_commerce_app/controller/product/ProductController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());

  final RxInt _selectedIndex = 0.obs;
  int? _initialId;

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg != null && arg is int) {
      _initialId = arg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (categoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.categoryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined,
                    size: 60,
                    color: theme.colorScheme.onSurface.withOpacity(0.3)),
                const SizedBox(height: 10),
                Text(
                  "No categories found",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          );
        }

        if (_initialId != null) {
          final index = categoryController.categoryList
              .indexWhere((c) => c.id == _initialId);
          if (index != -1) {
            _selectedIndex.value = index;
            categoryController.selectedCategoryId.value = _initialId!;
            final initialIdToFetch = _initialId!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              categoryController.fetchSubCategories(initialIdToFetch);
            });
          }
          _initialId = null;
        }

        if (_selectedIndex.value >= categoryController.categoryList.length ||
            _selectedIndex.value < 0) {
          _selectedIndex.value = 0;
        }

        if (categoryController.subCategoryList.isEmpty &&
            categoryController.categoryList.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            categoryController.fetchSubCategories(
                categoryController.categoryList[_selectedIndex.value].id);
          });
        }

        return Row(
          children: [
            Container(
              width: 85,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                itemCount: categoryController.categoryList.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected = _selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () {
                        _selectedIndex.value = index;
                        categoryController.selectedCategoryId.value =
                            categoryController.categoryList[index].id;
                        categoryController.fetchSubCategories(
                            categoryController.categoryList[index].id);
                      },
                      child: Container(
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.05)
                            : Colors.transparent,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
                                          width: 2),
                                    ),
                                    child: ClipOval(
                                      child: Container(
                                        color: theme.colorScheme.surface,
                                        child: categoryController
                                                    .categoryList[index]
                                                    .imageUrl !=
                                                null
                                            ? Image.network(
                                                categoryController
                                                    .categoryList[index]
                                                    .imageUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) => Icon(
                                                    Icons.category,
                                                    color: theme
                                                        .colorScheme.onSurface
                                                        .withOpacity(0.5)),
                                              )
                                            : Icon(Icons.category,
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    categoryController.categoryList[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 4,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            // Right Content - Subcategories
            Expanded(
              child: Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Title Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            categoryController
                                .categoryList[_selectedIndex.value].name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${categoryController.subCategoryList.length} Items',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: Obx(() {
                        if (categoryController.subCategoryList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.grid_off,
                                    size: 50,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.2)),
                                const SizedBox(height: 10),
                                Text(
                                  "No subcategories",
                                  style: GoogleFonts.poppins(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8, // Taller cards
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: categoryController.subCategoryList.length,
                          itemBuilder: (context, index) {
                            final subCat =
                                categoryController.subCategoryList[index];
                            return GestureDetector(
                              onTap: () {
                                productController
                                    .fetchProductsBySubCategory(subCat.id);
                                Get.toNamed(AppRoutes.productListPage);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.05),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: subCat.imageUrl != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                ),
                                                child: Image.network(
                                                  subCat.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Center(
                                                        child: Icon(Icons.image,
                                                            color: theme
                                                                .colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                    0.3)));
                                                  },
                                                ),
                                              )
                                            : Center(
                                                child: Icon(Icons.image,
                                                    color: theme
                                                        .colorScheme.onSurface
                                                        .withOpacity(0.3))),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            subCat.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
