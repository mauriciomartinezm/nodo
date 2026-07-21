import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

/// Campo con apariencia de dropdown que, al tocarlo, abre una lista con
/// checkboxes para elegir varias opciones a la vez.
class MultiSelectDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> options;
  final List<T> selectedValues;
  final String Function(T option) labelBuilder;
  final ValueChanged<List<T>> onChanged;
  final String? errorText;

  const MultiSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.labelBuilder,
    required this.onChanged,
    this.hint = 'Selecciona una o varias opciones',
    this.errorText,
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<List<T>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var tempSelected = List<T>.from(selectedValues);
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.subtitle
                          .copyWith(color: AppColors.blue),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: options.map((option) {
                          final isSelected = tempSelected.contains(option);
                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(labelBuilder(option)),
                            activeColor: AppColors.blue,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (checked) {
                              setSheetState(() {
                                if (checked == true) {
                                  tempSelected.add(option);
                                } else {
                                  tempSelected.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, tempSelected),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Listo'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  void _removeValue(T value) {
    final updated = List<T>.from(selectedValues)..remove(value);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _openPicker(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              errorText: errorText,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        if (selectedValues.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedValues.map((value) {
              return Chip(
                label: Text(
                  labelBuilder(value),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.blue,
                deleteIconColor: Colors.white,
                onDeleted: () => _removeValue(value),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
