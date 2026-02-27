import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/biometrics_cubit.dart';
import 'package:moon_design/moon_design.dart';

class IDCardInput extends StatelessWidget {
  const IDCardInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsCubit, BiometricsState>(
      buildWhen: (previous, current) =>
          previous.idCardPath != current.idCardPath,
      builder: (context, state) {
        return _IDCardInputImpl(
          idCardPath: state.idCardPath,
          onIDCardChanged: (path) =>
              BlocProvider.of<BiometricsCubit>(context).setIDCard(path),
        );
      },
    );
  }
}

class _IDCardInputImpl extends StatefulWidget {
  final String? idCardPath;
  final ValueChanged<String> onIDCardChanged;

  const _IDCardInputImpl({
    this.idCardPath,
    required this.onIDCardChanged,
  });

  @override
  State<_IDCardInputImpl> createState() => _IDCardInputImplState();
}

class _IDCardInputImplState extends State<_IDCardInputImpl> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      widget.onIDCardChanged(pickedFile.path);
    }
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.l10n.camera),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.l10n.gallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateText();
  }

  @override
  void didUpdateWidget(covariant _IDCardInputImpl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.idCardPath != oldWidget.idCardPath) {
      _updateText();
    }
  }

  void _updateText() {
    _controller.text =
        widget.idCardPath != null && widget.idCardPath!.isNotEmpty
            ? context.l10n.idCardUploaded
            : context.l10n.idCard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoonTextInput(
          hintText: context.l10n.idCard,
          controller: _controller,
          readOnly: true,
          leading: const Icon(MoonIcons.generic_loyalty_24_light),
          onTap: () => _showPickerOptions(context),
        ),
        if (widget.idCardPath != null && widget.idCardPath!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(widget.idCardPath!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
