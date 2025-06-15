import 'package:auto_route/auto_route.dart';
import 'package:easy_order/app/components/custom_form_field.dart';
import 'package:easy_order/app/components/snackbar_component.dart';
import 'package:easy_order/app/constants/constants.dart';
import 'package:easy_order/app/screens/landing/state/landing_screen_notifier.dart';
import 'package:easy_order/app/screens/line/state/line_notifier.dart';
import 'package:easy_order/app/screens/line/widgets/create_line_button.dart';
import 'package:easy_order/material_styles/app_color.dart';
import 'package:easy_order/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AddLinePage extends ConsumerStatefulWidget {
  final String? lineId;
  final String? lineName;

  const AddLinePage({
    super.key,
    this.lineId,
    this.lineName,
  });

  @override
  ConsumerState<AddLinePage> createState() => _AddLinePageState();
}

class _AddLinePageState extends ConsumerState<AddLinePage> {
  late TextEditingController _lineNameController;

  @override
  void initState() {
    super.initState();
    _lineNameController = TextEditingController();
    if (widget.lineId != null && widget.lineName != null) {
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
      appBar: _buildAppBar(lineState, context),
      body: Padding(
        padding: EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLineNameField(),
            CreateLineButton(
              lineNameController: _lineNameController,
              lineId: widget.lineId,
              ref: ref,
              lineState: lineState,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineNameField() => Padding(
        padding: EdgeInsets.only(top: spacing24, bottom: spacing32),
        child: CustomFormField.text(
          label: 'Line Name',
          controller: _lineNameController,
          hintText: 'Enter line name',
        ),
      );

  AppBar _buildAppBar(LineState lineState, BuildContext context) => AppBar(
        title: Text(widget.lineId != null ? 'Edit Line' : 'Add New Line'),
        elevation: 0,
        forceMaterialTransparency: true,
        actions: [
          if (widget.lineId != null)
            lineState.isDeleting
                ? _buildCircularBar()
                : _buildDeleteButton(context, lineState),
        ],
      );

  Widget _buildDeleteButton(BuildContext context, LineState lineState) =>
      IconButton(
        onPressed: () async {
          await ref.read(lineStateProvider.notifier).deleteLine(widget.lineId!);
          if (context.mounted) {
            if (lineState.error != null) {
              context.showErrorSnackBar(lineState.error!);
            } else {
              // Changing bottom nav index to 1
              ref.read(landingScreenStateProvider.notifier).changePage(1);
              context.router.replaceAll([AppRoutes.landing]);
            }
          }
        },
        icon: const Icon(Icons.delete),
      );

  Widget _buildCircularBar() => Padding(
        padding: EdgeInsets.only(right: spacing16),
        child: SizedBox(
          width: size24,
          height: size24,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            color: AppColor.buttonGreen,
          ),
        ),
      );
}
