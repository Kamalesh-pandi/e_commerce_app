import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/service/UserService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WishlistController extends GetxController {
  var wishlistProducts = <Product>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    final userService = Get.put(UserService());
    final wishlist = await userService.getWishlist();
    wishlistProducts.value = wishlist;
  }

  Future<void> addToWishlist(int productId) async {
    final userService = Get.put(UserService());
    await userService.addToWishlist(productId);
    loadWishlist();
  }

  Future<void> removeFromWishlist(int productId) async {
    final userService = Get.put(UserService());
    await userService.removeFromWishlist(productId);
    loadWishlist();
  }

  bool isInWishlist(Product product) {
    return wishlistProducts.any((p) => p.id == product.id);
  }

  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product)) {
      await removeFromWishlist(product.id!);
    } else {
      await addToWishlist(product.id!);
    }
  }
}
