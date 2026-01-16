import 'package:e_commerce_app/model/category_model.dart';
import 'package:e_commerce_app/model/subcategory_model.dart';
import 'package:e_commerce_app/service/CategoryService.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final categoryService = CategoryService();
  var categoryList = <Category>[].obs;
  var subCategoryList = <SubCategory>[].obs;
  var isLoading = true.obs;
  var selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final categories = await categoryService.getCategories();
      categoryList.assignAll(categories);
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSubCategories(int id) async {
    try { // set sub loading
      selectedCategoryId.value = id;
      final subCategories = await categoryService.getSubCategories(id);
      subCategoryList.assignAll(subCategories);
    } catch (e) {
      print("Error fetching subcategories: $e");
    } finally {
    }
  }
}
