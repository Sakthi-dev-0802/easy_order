import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/common_widgets/line_card.dart';
import 'package:easy_order/app/screens/line/providers/lines_provider.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinesList extends ConsumerWidget {
  const LinesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linesAsync = ref.watch(allLinesProvider);

    return linesAsync.when(
      data: (lines) => lines.isEmpty
          ? const Center(
              child: Text(
                'No Lines Available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            )
          : GridView.builder(
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
                    context.router.navigate(AppRoutes.clientsListPage(
                      lines[index].lineId,
                      lines[index].lineName,
                    ));
                  },
                );
              },
            ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
