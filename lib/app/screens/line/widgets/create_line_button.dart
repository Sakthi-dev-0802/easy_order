import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/sizing_constant.dart';
import 'package:easy_order/app/constants/spacing_constant.dart';
import 'package:easy_order/app/screens/landing/state/landing_screen_notifier.dart';
import 'package:easy_order/app/screens/line/state/line_notifier.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateLineButton extends StatelessWidget {
  final TextEditingController _lineNameController;
  final String? lineId;
  final WidgetRef ref;
  final LineState lineState;

  const CreateLineButton({
    super.key,
    required TextEditingController lineNameController,
    this.lineId,
    required this.ref,
    required this.lineState,
  }) : _lineNameController = lineNameController;

  Future<void> _onPressed(BuildContext context) async {
    if (_lineNameController.text.isEmpty) {
      context.showErrorSnackBar('Fill the line name');
    } else {
      if (lineId != null) {
        await ref
            .read(lineStateProvider.notifier)
            .updateLine(lineId!, _lineNameController.text);
        // Changing bottom nav index to 1
        ref.read(landingScreenStateProvider.notifier).changePage(1);
        if (context.mounted) {
          context.router.replaceAll([AppRoutes.landing]);
        }
      } else {
        await ref
            .read(lineStateProvider.notifier)
            .createLine(_lineNameController.text);
        if (context.mounted) {
          if (lineState.error != null) {
            context.showErrorSnackBar(lineState.error!);
          } else {
            context.router.back();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _onPressed(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.buttonGreen,
        padding: EdgeInsets.symmetric(vertical: spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child:
          lineState.isLoading ? _buildCirucularProgress() : _buildButtonText(),
    );
  }

  Widget _buildButtonText() => Text(
        lineId != null ? 'Update Line' : 'Save Line',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildCirucularProgress() => Center(
        child: SizedBox(
          width: size20,
          height: size20,
          child: const CircularProgressIndicator(
            color: AppColor.backgroundWhite,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
          ),
        ),
      );
}
