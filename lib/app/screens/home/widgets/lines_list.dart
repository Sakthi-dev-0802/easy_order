import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/common_widgets/line_card.dart';
import 'package:easy_order/app/components/progress_bar.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/line/providers/lines_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.route_outlined,
                    size: size64,
                    color: AppColor.textDarkGray.withOpacity(0.4),
                  ),
                  SizedBox(height: spacing16),
                  Text(
                    'No Lines Available',
                    style: AppTextStyle.titleMediumDark.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                return LineCard(
                  lineName: line.lineName,
                  onTap: () {
                    context.router.navigate(AppRoutes.clientsListPage(
                      line.lineId,
                      line.lineName,
                    ));
                  },
                );
              },
            ),
      loading: () => const Center(
        child: ProgressBarWidget(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
