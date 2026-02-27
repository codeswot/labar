import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_state.dart';
import 'package:labar_app/features/home/presentation/widgets/supabase_image.dart';
import 'package:ui_library/ui_library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ApplicationDetailsPage extends StatelessWidget {
  final ApplicationEntity application;

  const ApplicationDetailsPage({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final currentApp = state.application ?? application;
        final statusColor = _getStatusColor(context, currentApp.status);
        final canEdit = currentApp.status == ApplicationStatus.initial;

        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.viewApplication),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const Icon(MoonIcons.generic_edit_24_regular),
                  onPressed: () {
                    getIt<ApplicationFormCubit>().loadApplication(currentApp);
                    context.router.push(const ApplicationFormRoute());
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: currentApp.passportUrl != null
                              ? SupabaseImage(
                                  imageUrl: currentApp.passportUrl!,
                                  fit: BoxFit.cover,
                                  onRefresh: () => context
                                      .read<HomeCubit>()
                                      .refreshApplication(),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                          MoonIcons.generic_user_24_regular,
                                          size: 50),
                                )
                              : const Icon(MoonIcons.generic_user_24_regular,
                                  size: 50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      MoonTag(
                        tagSize: MoonTagSize.sm,
                        backgroundColor: statusColor.withValues(alpha: 0.2),
                        label: Text(
                          currentApp.status.name.toUpperCase(),
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _SectionTitle(title: context.l10n.personalInformation),
                _DetailItem(
                    label: context.l10n.firstName, value: currentApp.firstName),
                _DetailItem(
                    label: context.l10n.lastName, value: currentApp.lastName),
                _DetailItem(
                    label: context.l10n.gender, value: currentApp.gender),
                _DetailItem(
                  label: context.l10n.dateOfBirth,
                  value: currentApp.dateOfBirth
                          ?.toLocal()
                          .toString()
                          .split(' ')[0] ??
                      '-',
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: context.l10n.contactInformation),
                _DetailItem(
                    label: context.l10n.phoneNumber,
                    value: currentApp.phoneNumber),
                _DetailItem(label: context.l10n.state, value: currentApp.state),
                _DetailItem(
                    label: context.l10n.localGovernment, value: currentApp.lga),
                const SizedBox(height: 24),
                _SectionTitle(title: context.l10n.farmInformation),
                _DetailItem(
                    label: context.l10n.cropType, value: currentApp.cropType),
                _DetailItem(
                    label: context.l10n.farmSizeHectares,
                    value: currentApp.farmSize ?? '-'),
                _DetailItem(
                    label: context.l10n.farmDescription,
                    value: currentApp.farmLocation ?? '-'),
                const SizedBox(height: 24),
                _SectionTitle(title: context.l10n.bankDetails),
                _DetailItem(
                    label: context.l10n.bankName,
                    value: currentApp.bankName ?? '-'),
                _DetailItem(
                    label: context.l10n.accountNumber,
                    value: currentApp.accountNumber ?? '-'),
                _DetailItem(
                    label: context.l10n.accountName,
                    value: currentApp.accountName ?? '-'),
                const SizedBox(height: 32),
                if (currentApp.signatureUrl != null) ...[
                  _SectionTitle(title: context.l10n.signature),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.moonColors!.beerus),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SupabaseImage(
                      imageUrl: currentApp.signatureUrl!,
                      fit: BoxFit.contain,
                      onRefresh: () =>
                          context.read<HomeCubit>().refreshApplication(),
                    ),
                  ),
                ],
                if (currentApp.idCardUrl != null) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: context.l10n.idCard),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.moonColors!.beerus),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SupabaseImage(
                      imageUrl: currentApp.idCardUrl!,
                      fit: BoxFit.contain,
                      onRefresh: () =>
                          context.read<HomeCubit>().refreshApplication(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BuildContext context, ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.initial:
        return context.moonColors!.piccolo;
      case ApplicationStatus.inReview:
        return context.moonColors!.krillin;
      case ApplicationStatus.approved:
        return context.moonColors!.roshi;
      case ApplicationStatus.rejected:
        return context.moonColors!.chichi;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: context.moonTypography?.heading.text16.copyWith(
          color: context.moonColors?.piccolo,
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: context.moonTypography?.body.text14
                  .copyWith(color: context.moonColors?.trunks)),
          Text(value,
              style: context.moonTypography?.body.text14
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
