import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/UserController.dart';
import '../../model/user_model.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final UserController userController = Get.find<UserController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'My Addresses',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.colorScheme.primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final addresses = userController.user.value?.addresses ?? [];

          if (addresses.isEmpty) {
            return Center(
              child: Text(
                'No addresses found.',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: address.isDefault == true
                      ? BorderSide(color: theme.colorScheme.primary, width: 2)
                      : BorderSide(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                address.type == 'Work'
                                    ? Icons.work_outline
                                    : Icons.home_outlined,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                address.type ?? 'Home',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          if (address.isDefault == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Default',
                                style: GoogleFonts.poppins(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Radio<int>(
                              value: address.id!,
                              groupValue: addresses
                                  .firstWhere((a) => a.isDefault == true,
                                      orElse: () => Address())
                                  .id,
                              onChanged: (val) {
                                if (val != null) {
                                  userController.setDefaultAddress(val);
                                }
                              },
                              activeColor: theme.colorScheme.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.name ?? '',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${address.street}, ${address.landmark ?? ''}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.grey[400]),
                                ),
                                Text(
                                  '${address.city}, ${address.state} - ${address.pinCode}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.grey[400]),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.phone_outlined,
                                        size: 16, color: Colors.grey[400]),
                                    const SizedBox(width: 6),
                                    Text(
                                      address.phoneNumber ?? '',
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              _showAddressDialog(context, userController,
                                  address: address);
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: Text('Edit',
                                style: GoogleFonts.poppins(
                                    color: theme.colorScheme.primary)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              side: BorderSide(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3)),
                              foregroundColor: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              if (address.id != null) {
                                userController.removeAddress(address.id!);
                              }
                            },
                            icon: const Icon(Icons.delete_outline,
                                size: 16, color: Colors.red),
                            label: Text('Delete',
                                style: GoogleFonts.poppins(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              side: BorderSide(
                                  color: Colors.red.withOpacity(0.3)),
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddressDialog(context, userController);
          },
          backgroundColor: theme.colorScheme.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text('Add New Address',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, UserController controller,
      {Address? address}) {
    final theme = Theme.of(context);
    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController =
        TextEditingController(text: address?.phoneNumber ?? '');
    final streetController = TextEditingController(text: address?.street ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final zipController = TextEditingController(text: address?.pinCode ?? '');

    final landmarkController =
        TextEditingController(text: address?.landmark ?? '');
    String type = address?.type ?? 'Home';

    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address == null ? 'Add New Address' : 'Edit Address',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text('Address Type',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[400])),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text('Home'),
                        selected: type == 'Home',
                        onSelected: (bool selected) {
                          setState(() {
                            type = 'Home';
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surface,
                        labelStyle: GoogleFonts.poppins(
                          color: type == 'Home'
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: type == 'Home'
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: Text('Work'),
                        selected: type == 'Work',
                        onSelected: (bool selected) {
                          setState(() {
                            type = 'Work';
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surface,
                        labelStyle: GoogleFonts.poppins(
                          color: type == 'Work'
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: type == 'Work'
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        labelText: 'Phone', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: streetController,
                    decoration: const InputDecoration(
                        labelText: 'Street', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: landmarkController,
                    decoration: const InputDecoration(
                        labelText: 'Landmark', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                        labelText: 'City', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stateController,
                    decoration: const InputDecoration(
                        labelText: 'State', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: zipController,
                    decoration: const InputDecoration(
                        labelText: 'Pin Code', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newAddress = Address(
                            id: address?.id,
                            name: nameController.text,
                            phoneNumber: phoneController.text,
                            street: streetController.text,
                            city: cityController.text,
                            state: stateController.text,
                            pinCode: zipController.text,
                            landmark: landmarkController.text,
                            type: type,
                            isDefault: address?.isDefault ?? false);

                        if (address == null) {
                          controller.addAddress(newAddress);
                        } else {
                          if (address.id != null)
                            controller.updateAddress(address.id!, newAddress);
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: Text('Save Address',
                          style: GoogleFonts.poppins(
                              color: theme.colorScheme.onPrimary)),
                    ),
                  )
                ],
              ),
            ));
      }),
      isScrollControlled: true,
    );
  }
}
