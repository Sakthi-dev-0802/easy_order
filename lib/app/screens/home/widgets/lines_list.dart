import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/screens/line/line_screen.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

class LinesList extends StatelessWidget {
  const LinesList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return LineCard(
          lineName: "Line${index + 1}",
          onTap: () {
            context.router.navigate(AppRoutes.clientsListPage);
          },
        );
      },
    );
  }
}
