import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/common_widgets/line_card.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/firebase_services/model/line_model.dart';
import 'package:easy_order/app/screens/line/providers/lines_provider.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/material_styles/app_text_style.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoadLinesPage extends ConsumerWidget {
  const LoadLinesPage({super.key});

  void _onLineTap(BuildContext context, LineModel line) =>
      context.router.navigate(
        AppRoutes.loadReportPage(
          line.lineId,
          line.lineName,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linesAsync = ref.watch(allLinesProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: linesAsync.when(
          data: (lines) =>
              lines.isEmpty ? _buildEmtyListView() : _buildLines(lines),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildLines(List<LineModel> lines) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: spacing16,
          mainAxisSpacing: spacing16,
        ),
        itemCount: lines.length,
        itemBuilder: (context, index) => LineCard(
          lineName: lines[index].lineName,
          onTap: () => _onLineTap(context, lines[index]),
        ),
      );

  Widget _buildEmtyListView() => Center(
        child: Text(
          'No Lines Available',
          style: AppTextStyle.titleMediumDark
              .copyWith(fontWeight: FontWeight.w500),
        ),
      );

  AppBar _buildAppBar() => AppBar(
        title: const Text('Select Line'),
        elevation: 0,
        forceMaterialTransparency: true,
      );
}
