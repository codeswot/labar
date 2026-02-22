import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';
import 'package:labar_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_state.dart';
import 'package:labar_app/features/home/presentation/widgets/supabase_image.dart';
import 'package:ui_library/ui_library.dart';

class SubmittedView extends StatelessWidget {
  const SubmittedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: MoonCircularLoader());
        }

        final application = state.application;
        if (application == null) {
          return Center(
            child: Text(
              context.l10n.somethingWentWrong,
              style: context.moonTypography?.body.text16,
            ),
          );
        }

        final statusColor = _getStatusColor(context, application.status);
        final fullName = [
          application.firstName,
          if (application.otherNames != null &&
              application.otherNames!.isNotEmpty)
            application.otherNames,
          application.lastName
        ].join(' ');

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (application.proofOfPaymentPath == null ||
                  application.proofOfPaymentPath!.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.moonColors?.gohan,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.moonColors?.piccolo ?? Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.proofOfPaymentRequired,
                        style: context.moonTypography?.heading.text16,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton.filled(
                          onTap: () =>
                              context.read<HomeCubit>().uploadProofOfPayment(),
                          label: Text(context.l10n.uploadProofOfPayment),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (application.status == ApplicationStatus.approved) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.moonColors?.roshi.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.moonColors?.roshi ?? Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.l10n.applicationApprovedSuccess,
                              style: context.moonTypography?.heading.text16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.filled(
                              onTap: () => context.router.push(
                                AllocatedResourcesRoute(
                                    applicationId: application.id),
                              ),
                              label: Text(context.l10n.viewAllocatedResources,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.moonColors?.gohan,
                                  )),
                              backgroundColor:
                                  context.moonColors?.roshi ?? Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppButton.outlined(
                              onTap: () => context.router.push(
                                AssignedWarehouseRoute(
                                    applicationId: application.id),
                              ),
                              label: Text(context.l10n.viewAssignedWarehouse,
                                  style: const TextStyle(fontSize: 12)),
                              borderColor: context.moonColors?.roshi,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.moonColors?.gohan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getStatusMessage(context, application),
                        style: context.moonTypography?.body.text14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.faqCheckOut,
                  style: context.moonTypography?.body.text12.copyWith(
                    color: context.moonColors?.trunks,
                  ),
                ),
                const SizedBox(height: 8),
                MoonAccordion(
                  accordionSize: MoonAccordionSize.sm,
                  headerPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  label: Text(context.l10n.faqQuestion1),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(context.l10n.faqAnswer1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                MoonAccordion(
                  accordionSize: MoonAccordionSize.sm,
                  headerPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  label: Text(context.l10n.faqQuestion2),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(context.l10n.faqAnswer2),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                MoonAccordion(
                  accordionSize: MoonAccordionSize.sm,
                  headerPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  label: Text(context.l10n.faqQuestion3),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(context.l10n.faqAnswer3),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Divider(
                thickness: 0.2,
                color: context.moonColors?.piccolo,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.router.push(
                        ApplicationDetailsRoute(application: application));
                  },
                  child: Text(
                    context.l10n.viewApplication,
                    style: TextStyle(
                      color: context.moonColors?.piccolo,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 106,
                  height: 106,
                  child: ClipOval(
                    child: application.passportUrl != null
                        ? SupabaseImage(
                            imageUrl: application.passportUrl!,
                            fit: BoxFit.cover,
                            onRefresh: () =>
                                context.read<HomeCubit>().refreshApplication(),
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(MoonIcons.generic_user_24_regular,
                                    size: 40),
                          )
                        : const Icon(MoonIcons.generic_user_24_regular,
                            size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: context.moonTypography?.heading.text18,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              MoonTag(
                tagSize: MoonTagSize.sm,
                backgroundColor: statusColor.withValues(alpha: 0.2),
                label: Text(
                  application.status.name.toUpperCase(),
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              _SummarySection(
                title: context.l10n.personalInformation,
                children: [
                  _SummaryItem(
                      label: context.l10n.gender, value: application.gender),
                  _SummaryItem(
                      label: context.l10n.phoneNumber,
                      value: application.phoneNumber),
                ],
              ),
              const SizedBox(height: 24),
              _SummarySection(
                title: context.l10n.farmInformation,
                children: [
                  _SummaryItem(
                      label: context.l10n.cropType,
                      value: application.cropType),
                  _SummaryItem(
                      label: context.l10n.farmSizeHectares,
                      value: application.farmSize ?? '-'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(BuildContext context, ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.initial:
        return context.moonColors!.bulma;
      case ApplicationStatus.inReview:
        return context.moonColors!.krillin;
      case ApplicationStatus.approved:
        return context.moonColors!.roshi;
      case ApplicationStatus.rejected:
        return context.moonColors!.chichi;
    }
  }

  String _getStatusMessage(
      BuildContext context, ApplicationEntity application) {
    final name = '${application.firstName} ${application.lastName}';
    switch (application.status) {
      case ApplicationStatus.initial:
        return context.l10n.applicationMessageInitial(name);
      case ApplicationStatus.inReview:
        return context.l10n.applicationMessageInReview(name);
      case ApplicationStatus.approved:
        return context.l10n.applicationMessageApproved(name);
      case ApplicationStatus.rejected:
        return context.l10n.applicationMessageRejected(name);
    }
  }
}

class _SummarySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SummarySection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.moonTypography?.heading.text16.copyWith(
            color: context.moonColors?.piccolo,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

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
