import 'package:easy_order/material_styles/material_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField._({
    required this.label,
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.readOnly = false,
    this.onChanged,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.value,
    this.items = const [],
    this.displayItems = const [],
    this.obscureText = false,
    this.togglePassword,
    required this.fieldType,
  });

  factory CustomFormField.text({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String?>? onChanged,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    Key? key,
  }) {
    return CustomFormField._(
      key: key,
      label: label,
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLength: maxLength ?? TextField.noMaxLength,
      readOnly: readOnly,
      onChanged: onChanged,
      floatingLabelBehavior: floatingLabelBehavior,
      fieldType: FormFieldType.text,
    );
  }

  factory CustomFormField.password({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool enabled = true,
    ValueChanged<String?>? onChanged,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    Key? key,
  }) {
    return CustomFormField._(
      key: key,
      label: label,
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.visiblePassword,
      enabled: enabled,
      onChanged: onChanged,
      floatingLabelBehavior: floatingLabelBehavior,
      fieldType: FormFieldType.password,
      obscureText: true,
      togglePassword: true,
    );
  }

  factory CustomFormField.dropdown({
    required String label,
    required String? value,
    required List<String> items,
    List<String>? displayItems,
    required ValueChanged<String?> onChanged,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    Key? key,
  }) {
    return CustomFormField._(
      key: key,
      label: label,
      value: value,
      items: items,
      displayItems: displayItems ?? items,
      onChanged: onChanged,
      fieldType: FormFieldType.dropdown,
      floatingLabelBehavior: floatingLabelBehavior,
    );
  }

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLength;
  final bool readOnly;
  final ValueChanged<String?>? onChanged;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool obscureText;
  final bool? togglePassword;

  // For DropDown
  final String? value;
  final List<String> items;
  final List<String> displayItems;

  // Type
  final FormFieldType fieldType;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  InputDecoration _getFieldDecoration() {
    return InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      labelStyle: GoogleFonts.openSans(
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        fontSize: 18,
      ),
      floatingLabelStyle: GoogleFonts.openSans(
        fontWeight: FontWeight.w500,
        color: AppColor.borderGreen,
        fontSize: 18,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.borderGreen),
      ),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: widget.togglePassword == true
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }

  Widget _buildTextField() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller ?? TextEditingController(),
      builder: (context, value, child) {
        return TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          maxLines: widget.keyboardType == TextInputType.multiline ? null : 1,
          minLines: widget.keyboardType == TextInputType.multiline ? 3 : null,
          decoration: _getFieldDecoration(),
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            fontSize: 18,
          ),
          onChanged: widget.onChanged,
          textCapitalization: TextCapitalization.sentences,
        );
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: widget.value,
      dropdownColor: AppColor.backgroundWhite,
      items: List.generate(
        widget.items.length,
        (index) => DropdownMenuItem<String>(
          value: widget.items[index],
          child: Text(widget.displayItems[index]),
        ),
      ),
      onChanged: widget.enabled ? widget.onChanged : null,
      decoration: _getFieldDecoration(),
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        fontSize: 18,
      ),
      icon: const Icon(Icons.arrow_drop_down, size: 24, color: Colors.black87),
    );
  }

  Widget _buildField() {
    switch (widget.fieldType) {
      case FormFieldType.text:
      case FormFieldType.password:
        return _buildTextField();
      case FormFieldType.dropdown:
        return _buildDropdownField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildField();
  }
}

enum FormFieldType { text, password, dropdown }
