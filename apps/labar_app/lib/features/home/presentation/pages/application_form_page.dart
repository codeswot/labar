import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/application_form.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

@RoutePage()
class ApplicationFormPage extends StatelessWidget {
  const ApplicationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ApplicationFormCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.applicationForm),
        ),
        body: const ApplicationForm(),
      ),
    );
  }
}
