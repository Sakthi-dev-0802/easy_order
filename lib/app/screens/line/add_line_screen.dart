import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/landing/state/landing_screen_notifier.dart';
import 'package:easy_order/app/screens/line/state/line_notifier.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AddLinePage extends ConsumerStatefulWidget {
  final String? lineId;
  final String? lineName;
  const AddLinePage({super.key, this.lineId, this.lineName});

  @override
  ConsumerState<AddLinePage> createState() => _AddLinePageState();
}

class _AddLinePageState extends ConsumerState<AddLinePage> {
  late TextEditingController _lineNameController;

  @override
  void initState() {
    super.initState();
    _lineNameController = TextEditingController();
    if (widget.lineName != null) {
      _lineNameController.text = widget.lineName!;
    }
  }

  @override
  void dispose() {
    _lineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lineState = ref.watch(lineStateProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      appBar: AppBar(
        title: Text(widget.lineId != null ? 'Edit Line' : 'Add New Line'),
        elevation: 0,
        actions: [
          if (widget.lineId != null)
            lineState.isDeleting
                ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        color: AppColor.buttonGreen,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      await ref
                          .read(lineStateProvider.notifier)
                          .deleteLine(widget.lineId!);
                      if (context.mounted) {
                        if (lineState.error != null) {
                          context.showErrorSnackBar(lineState.error!);
                        } else {
                          ref
                              .read(landingScreenStateProvider.notifier)
                              .changePage(1);
                          context.router.replaceAll([AppRoutes.landing]);
                        }
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: spacing24),
            CustomFormField.text(
              label: 'Line Name',
              controller: _lineNameController,
              hintText: 'Enter line name',
            ),
            SizedBox(height: spacing32),  
            ElevatedButton(
              onPressed: () async {
                if (_lineNameController.text.isEmpty) {
                  context.showErrorSnackBar('Fill the line name');
                } else {
                  if (widget.lineId != null) {
                    await ref
                        .read(lineStateProvider.notifier)
                        .updateLine(widget.lineId!, _lineNameController.text);
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.buttonGreen,
                padding: EdgeInsets.symmetric(vertical: spacing16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: lineState.isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    )
                  : Text(
                      widget.lineId != null ? 'Update Line' : 'Save Line',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
