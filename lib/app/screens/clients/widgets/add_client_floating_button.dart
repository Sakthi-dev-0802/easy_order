import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';

class AddClientFloatingButton extends StatelessWidget {
  final String? lineId;

  const AddClientFloatingButton({
    super.key,
    required this.lineId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size56,
      height: size56,
      decoration: _buildBoxDecoration(),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) => FloatingActionButton(
        onPressed: () {
          context.router.push(AppRoutes.addClientPage(lineId: lineId));
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: size28,
        ),
      );

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF298F05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF298F05).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      );
}
