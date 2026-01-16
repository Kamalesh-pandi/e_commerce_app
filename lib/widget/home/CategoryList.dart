import 'package:e_commerce_app/controller/category/CategoryController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return SizedBox(
      height: size.height * 0.2,
      child: Obx(() {
        if (categoryController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (categoryController.categoryList.isEmpty) {
          return Center(child: Text("No Categories"));
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryController.categoryList.length,
          itemBuilder: (context, index) {
            return _buildCategoryItem(
                categoryController.categoryList[index].id,
                categoryController.categoryList[index].name,
                categoryController.categoryList[index].imageUrl,
                size,
                theme);
          },
        );
      }),
    );
  }

  Widget _buildCategoryItem(
      int id, String title, String? imageUrl, size, theme) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.categoryPage, arguments: id);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SizedBox(
          width: 70,
          child: Column(
            children: [
              Container(
                width: size.width * 0.3,
                height: size.height * 0.08,
                padding: imageUrl == null
                    ? const EdgeInsets.all(15)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/not_found_image.webp",
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : Icon(Icons.category,
                        color: theme.colorScheme.onSurface, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.surface,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
