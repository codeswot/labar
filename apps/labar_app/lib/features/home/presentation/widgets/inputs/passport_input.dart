import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/biometrics_cubit.dart';
import 'package:moon_design/moon_design.dart';

class PassportInput extends StatelessWidget {
  const PassportInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsCubit, BiometricsState>(
      buildWhen: (previous, current) =>
          previous.passportPath != current.passportPath,
      builder: (context, state) {
        return _PassportInputImpl(
          passportPath: state.passportPath,
          onPassportChanged: (path) =>
              BlocProvider.of<BiometricsCubit>(context).setPassport(path),
        );
      },
    );
  }
}

class _PassportInputImpl extends StatefulWidget {
  final String? passportPath;
  final ValueChanged<String> onPassportChanged;

  const _PassportInputImpl({
    this.passportPath,
    required this.onPassportChanged,
  });

  @override
  State<_PassportInputImpl> createState() => _PassportInputImplState();
}

class _PassportInputImplState extends State<_PassportInputImpl> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      widget.onPassportChanged(pickedFile.path);
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
  void didUpdateWidget(covariant _PassportInputImpl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.passportPath != oldWidget.passportPath) {
      _updateText();
    }
  }

  void _updateText() {
    _controller.text =
        widget.passportPath != null && widget.passportPath!.isNotEmpty
            ? context.l10n.imageSelected
            : context.l10n.passportPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoonTextInput(
          hintText: context.l10n.passportPhoto,
          controller: _controller,
          readOnly: true,
          leading: const Icon(MoonIcons.generic_picture_24_light),
          onTap: () => _showPickerOptions(context),
        ),
        if (widget.passportPath != null && widget.passportPath!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(widget.passportPath!),
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
