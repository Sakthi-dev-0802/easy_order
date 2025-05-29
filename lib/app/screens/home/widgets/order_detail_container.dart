import 'package:flutter/material.dart';

class OrderDetailContainer extends StatelessWidget {
  const OrderDetailContainer({super.key});

  @override
  Widget build(BuildContext context) {
    const double borderWidth = 2.0;
    final BorderRadius borderRadius = BorderRadius.circular(8.0);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2196F3), // Material Blue
            Color(0xFF298F05),
          ],
        ),
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(borderWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius.subtract(
              BorderRadius.circular(borderWidth),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: borderRadius,
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "1001",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
