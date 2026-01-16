import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';
import '../service/UserService.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  var user = Rxn<User>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final fetchedUser = await _userService.getUserProfile();
      if (fetchedUser != null) {
        user.value = fetchedUser;
        print(user.value);
      } else {
        Get.snackbar('Error', 'Failed to load profile',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while loading profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(User updatedUserProfile) async {
    try {
      isLoading.value = true;
      final result = await _userService.updateUserProfile(updatedUserProfile);
      if (result != null) {
        user.value = result;
        Get.snackbar('Success', 'Profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File file = File(image.path);
        final bytes = await file.readAsBytes();
        final String base64Image = base64Encode(bytes);

        if (user.value != null) {
          String formattedImage = "data:image/jpeg;base64,$base64Image";

          final updatedUser = User(
              id: user.value!.id,
              name: user.value!.name,
              email: user.value!.email,
              phoneNumber: user.value!.phoneNumber,
              role: user.value!.role,
              profileImage: formattedImage,
              isPhoneVerified: user.value!.isPhoneVerified,
              addresses: user.value!.addresses);

          await updateUser(updatedUser);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }

  // Address Management
  Future<void> addAddress(Address address) async {
    try {
      isLoading.value = true;
      final result = await _userService.addAddress(address);
      if (result != null) {
        await loadUserProfile();
        Get.snackbar('Success', 'Address added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeAddress(int addressId) async {
    try {
      isLoading.value = true;
      final success = await _userService.removeAddress(addressId);
      if (success) {
        await loadUserProfile();
        Get.snackbar('Success', 'Address removed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      } else {
        Get.snackbar('Error', 'Failed to remove address',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(int addressId, Address address) async {
    try {
      isLoading.value = true;
      final result = await _userService.updateAddress(addressId, address);
      if (result != null) {
        await loadUserProfile();
        Get.snackbar('Success', 'Address updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(int addressId) async {
    try {
      isLoading.value = true;
      final result = await _userService.setDefaultAddress(addressId);
      if (result != null) {
        await loadUserProfile();
        Get.snackbar('Success', 'Default address updated',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to set default address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }
}
