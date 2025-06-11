// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/report_cubit/report_cubit.dart';
import '../screens/assigned_report_screen.dart'; 

class FilterBar extends StatelessWidget {
  final ReportsCubit cubit;
  final ColorScheme colorScheme;
  final BuildContext parentContext;

  const FilterBar({
    Key? key,
    required this.cubit,
    required this.colorScheme,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // شاشة كبيرة
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: BlocBuilder<ReportsCubit, dynamic>(
              bloc: cubit,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cubit.statusFilters.map<Widget>((status) {
                    final isSelected = status == cubit.selectedStatus;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(
                          statusLabels[status] ?? status,
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => cubit.filterByStatus(status),
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surfaceVariant,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          );
        } else {
          // شاشة صغيرة
          return SizedBox(
            height: 80,
            child: BlocBuilder<ReportsCubit, dynamic>(
              bloc: cubit,
              builder: (context, state) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: cubit.statusFilters.length,
                  itemBuilder: (context, index) {
                    final status = cubit.statusFilters[index];
                    final isSelected = status == cubit.selectedStatus;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: ChoiceChip(
                        label: Text(
                          statusLabels[status] ?? status,
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => cubit.filterByStatus(status),
                        selectedColor: colorScheme.primary,
                        backgroundColor: colorScheme.surfaceVariant,
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
