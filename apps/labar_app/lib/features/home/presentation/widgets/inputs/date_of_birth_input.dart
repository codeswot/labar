import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:moon_design/moon_design.dart';

class DateOfBirthInput extends StatelessWidget {
  const DateOfBirthInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        final cubit = BlocProvider.of<PersonalInfoCubit>(context);
        return _DateOfBirthInputImpl(
          dateOfBirth: state.dateOfBirth,
          onDateChanged: cubit.dateOfBirthChanged,
        );
      },
    );
  }
}

class _DateOfBirthInputImpl extends StatefulWidget {
  final DateTime? dateOfBirth;
  final ValueChanged<DateTime> onDateChanged;

  const _DateOfBirthInputImpl({
    required this.dateOfBirth,
    required this.onDateChanged,
  });

  @override
  State<_DateOfBirthInputImpl> createState() => _DateOfBirthInputImplState();
}

class _DateOfBirthInputImplState extends State<_DateOfBirthInputImpl> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateText();
  }

  @override
  void didUpdateWidget(covariant _DateOfBirthInputImpl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dateOfBirth != oldWidget.dateOfBirth) {
      _updateText();
    }
  }

  void _updateText() {
    if (widget.dateOfBirth != null) {
      // Manual formatting or use DateFormat if available. Keeping manual for now.
      final day = widget.dateOfBirth!.day.toString().padLeft(2, '0');
      final month = widget.dateOfBirth!.month.toString().padLeft(2, '0');
      final year = widget.dateOfBirth!.year;
      final text = '$day/$month/$year';

      if (_controller.text != text) {
        _controller.text = text;
      }
    } else {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MoonTextInput(
      hintText: context.l10n.dateOfBirth,
      controller: _controller,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.dateOfBirth ?? DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          widget.onDateChanged(picked);
        }
      },
      leading: const Icon(MoonIcons
          .time_calendar_date_24_light), // Replaced generic Icon with MoonIcon if available, or keep generic if not sure. Material Icon is fine.
    );
  }
}
