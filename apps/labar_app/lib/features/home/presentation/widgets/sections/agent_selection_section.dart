import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/domain/entities/agent_entity.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/agent_selection_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/agent_selection_state.dart';
import 'package:ui_library/ui_library.dart';

class AgentSelectionSection extends StatefulWidget {
  const AgentSelectionSection({super.key});

  @override
  State<AgentSelectionSection> createState() => _AgentSelectionSectionState();
}

class _AgentSelectionSectionState extends State<AgentSelectionSection> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AgentSelectionCubit>()..loadAgents(),
      child: const _AgentSelectionContent(),
    );
  }
}

class _AgentSelectionContent extends StatelessWidget {
  const _AgentSelectionContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.selectAgent,
                style: context.moonTypography?.heading.text24,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.agentSelectionSubtitle,
                style: context.moonTypography?.body.text14.copyWith(
                  color: context.moonColors?.trunks,
                ),
              ),
              const SizedBox(height: 24),
              MoonTextInput(
                hintText: context.l10n.searchAgents,
                leading: const Icon(MoonIcons.generic_search_24_regular),
                onChanged: (v) =>
                    context.read<AgentSelectionCubit>().searchAgents(v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<AgentSelectionCubit, AgentSelectionState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: MoonCircularLoader());
              }

              if (state.error != null) {
                return Center(
                  child: AppErrorView(
                    subtitle: context.l10n.errorOccurred,
                    onRetry: () =>
                        context.read<AgentSelectionCubit>().loadAgents(),
                  ),
                );
              }

              if (state.filteredAgents.isEmpty) {
                return Center(
                  child: Text(context.l10n.noAgentsFound),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.filteredAgents.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Builder(builder: (context) {
                    final agent = state.filteredAgents[index];
                    final isSelected = context.select(
                      (ApplicationFormCubit cubit) =>
                          cubit.state.selectedAgent?.id == agent.id,
                    );

                    return _AgentCard(
                      agent: agent,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<ApplicationFormCubit>().selectAgent(agent);
                      },
                    );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AgentCard extends StatelessWidget {
  final AgentEntity agent;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgentCard({
    required this.agent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? context.moonColors?.piccolo
            : context.moonColors?.gohan,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? context.moonColors?.piccolo ?? Colors.blue
              : context.moonColors?.beerus ?? Colors.grey,
          width: 2,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: context.moonColors?.piccolo.withValues(alpha: 0.2) ??
                  Colors.blue.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: MoonMenuItem(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        leading: MoonAvatar(
          backgroundColor: isSelected
              ? context.moonColors?.goten.withValues(alpha: 0.2)
              : context.moonColors?.beerus,
          content: agent.avatarUrl != null
              ? Image.network(agent.avatarUrl!)
              : Text(agent.fullName.isNotEmpty ? agent.fullName[0] : '?'),
        ),
        label: Text(
          agent.fullName,
          style: context.moonTypography?.heading.text16.copyWith(
            color: isSelected
                ? context.moonColors?.goten
                : context.moonColors?.bulma,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          agent.email ?? '',
          style: context.moonTypography?.body.text12.copyWith(
            color: isSelected
                ? context.moonColors?.goten.withValues(alpha: 0.8)
                : context.moonColors?.trunks,
          ),
        ),
        trailing: isSelected
            ? Icon(
                MoonIcons.generic_check_alternative_24_regular,
                color: context.moonColors?.goten,
              )
            : null,
      ),
    );
  }
}
