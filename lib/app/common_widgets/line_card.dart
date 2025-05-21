import 'package:easy_order/app/constants/constants.dart';
import 'package:flutter/material.dart';

class LineCard extends StatelessWidget {
  final String lineName;
  final VoidCallback onTap;

  const LineCard({
    super.key,
    required this.lineName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2196F3),
                Color(0xFF298F05),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.line_axis,
                  size: size48,
                  color: Colors.white,
                ),
                SizedBox(height: spacing08),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing16),
                  child: Text(
                    lineName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
