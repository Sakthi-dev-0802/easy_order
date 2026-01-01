import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/items_model.dart';
import 'package:easy_order/app/firebase_services/services/items_service.dart';
import 'package:easy_order/app/screens/items/widgets/add_item_floating_button.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ItemsListPage extends StatelessWidget {
  const ItemsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: const Text('All Items'),
        backgroundColor: AppColor.backgroundWhite,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      floatingActionButton: const AddItemFloatingButton(),
      body: StreamBuilder<List<ItemsModel>>(
        stream: ItemsService.instance.getAllItemsWithDefaultsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: size64,
                    color: AppColor.textDarkGray.withOpacity(0.4),
                  ),
                  SizedBox(height: spacing16),
                  Text(
                    'No Items Available',
                    style: AppTextStyle.titleMediumDark.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(spacing16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  context.router.push(AppRoutes.addItemPageWithItem(item));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: spacing12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius12),
                    border: Border.all(
                      color: AppColor.borderMutedGray,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing16,
                      vertical: spacing12,
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(spacing10),
                      decoration: BoxDecoration(
                        color: AppColor.buttonGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(radius08),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColor.buttonGreen,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      item.itemName,
                      style: AppTextStyle.titleMediumDark.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.quantity != null) ...[
                          SizedBox(height: spacing04),
                          Text(
                            'Default Quantity: ${item.quantity}kg',
                            style: AppTextStyle.bodyLargeBoldDark.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (item.packType != null) ...[
                          SizedBox(height: spacing02),
                          Text(
                            'Pack Type: ${item.packType}',
                            style: AppTextStyle.bodyLargeBoldDark.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (item.noOfPack != null && item.noOfPack! > 0) ...[
                          SizedBox(height: spacing02),
                          Text(
                            'No of Pack: ${item.noOfPack}',
                            style: AppTextStyle.bodyLargeBoldDark.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
