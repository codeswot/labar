import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class SearchableDropdownInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final List<String> items;
  final String hintText;

  const SearchableDropdownInput({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.errorText,
    required this.items,
    required this.hintText,
  });

  @override
  State<SearchableDropdownInput> createState() =>
      _SearchableDropdownInputState();
}

class _SearchableDropdownInputState extends State<SearchableDropdownInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _showDropdown = false;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.text = widget.initialValue ?? '';
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && !_showDropdown) {}
    });
  }

  @override
  void didUpdateWidget(covariant SearchableDropdownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _searchController.text) {
      _searchController.text = widget.initialValue ?? '';
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((s) => s.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showDropdown = true;
    });
  }

  void _handleSelect(String value) {
    setState(() {
      _showDropdown = false;
      _searchController.text = value;
      widget.onChanged(value);
      _focusNode.unfocus();
    });
  }

  void _handleDropdownTapOutside() {
    setState(() {
      _showDropdown = false;
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MoonDropdown(
      show: _showDropdown,
      constrainWidthToChild: true,
      onTapOutside: () => _handleDropdownTapOutside(),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: _filteredItems.isEmpty
            ? const MoonMenuItem(
                label: Text('No results found.'),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _filteredItems.length,
                itemBuilder: (BuildContext _, int index) {
                  if (index >= _filteredItems.length) {
                    return const SizedBox.shrink();
                  }
                  final String option = _filteredItems[index];

                  return MoonMenuItem(
                    onTap: () => _handleSelect(option),
                    label: Text(option),
                  );
                },
              ),
      ),
      child: MoonFormTextInput(
        focusNode: _focusNode,
        hintText: widget.hintText,
        controller: _searchController,
        onTap: () => _performSearch(_searchController.text),
        onChanged: (String v) => _performSearch(v),
        errorText: widget.errorText,
        trailing: MoonButton.icon(
          buttonSize: MoonButtonSize.xs,
          hoverEffectColor: Colors.transparent,
          onTap: () {
            setState(() {
              _showDropdown = !_showDropdown;
              _filteredItems = widget.items;
            });
          },
          icon: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _showDropdown ? -0.5 : 0,
            child: const Icon(MoonIcons.controls_chevron_down_16_light),
          ),
        ),
      ),
    );
  }
}
