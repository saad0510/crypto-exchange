import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/extensions/context_ext.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.selected,
    required this.filters,
    required this.onSelected,
  });

  final int selected;
  final List<String> filters;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        filters.length,
        (i) => GestureDetector(
          onTap: () => onSelected(i),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 500),
            padding: AppPaddings.smallXY,
            margin: AppPaddings.normalX.copyWith(left: 0),
            decoration: BoxDecoration(
              color: selected == i ? context.primaryColor : context.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              filters[i],
              style: TextStyle(
                fontSize: 17,
                height: 0,
                color: selected == i ? AppColors.white : null,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
