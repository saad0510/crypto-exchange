import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../entities/stak_data.dart';
import 'stak_list_tile.dart';

class StakListView extends StatelessWidget {
  const StakListView({super.key, required this.staks});

  final List<StakData> staks;

  @override
  Widget build(BuildContext context) {
    if (staks.isEmpty) {
      return const Center(
        heightFactor: 10,
        child: Text('No staks to show'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: staks.length,
      separatorBuilder: (context, i) => AppSizes.smallY,
      itemBuilder: (context, i) {
        return StakListTile(stak: staks[i]);
      },
    );
  }
}
