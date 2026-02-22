import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/biometrics_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/passport_input.dart';
import 'package:signature/signature.dart';
import 'package:ui_library/ui_library.dart';

class BiometricsSection extends StatefulWidget {
  const BiometricsSection({super.key});

  @override
  State<BiometricsSection> createState() => _BiometricsSectionState();
}

class _BiometricsSectionState extends State<BiometricsSection> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsCubit, BiometricsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biometrics', // Updated title
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              const PassportInput(),
              const SizedBox(height: 16),
              Text(
                context.l10n.signature,
                style: context.moonTypography?.heading.text16,
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: context.moonColors?.beerus ?? Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      label: Text(context.l10n.clear),
                      onTap: () {
                        _controller.clear();
                        BlocProvider.of<BiometricsCubit>(context)
                            .setSignature(null);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.filled(
                      label: Text(context.l10n.saveSignature),
                      onTap: () async {
                        if (_controller.isNotEmpty) {
                          final signature = await _controller.toPngBytes();
                          if (signature != null) {
                            if (context.mounted) {
                              BlocProvider.of<BiometricsCubit>(context)
                                  .setSignature(signature);
                              MoonToast.show(
                                context,
                                label: Text(context.l10n.signatureSaved),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
