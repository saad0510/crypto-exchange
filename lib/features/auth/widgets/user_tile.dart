import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../entities/user_data.dart';
import 'user_image_widget.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.user,
    this.hasHero = false,
  });

  final bool hasHero;
  final UserData user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 24,
      contentPadding: AppPaddings.zero,
      visualDensity: VisualDensity.compact,
      leading: Hero(
        tag: hasHero ? AppConstants.pfpTag : UniqueKey(),
        child: UserImageWidget(
          radius: 24,
          imageUrl: user.picUrl,
        ),
      ),
      title: Text(
        user.name,
        style: context.textTheme.titleLarge?.copyWith(height: 0),
      ),
      subtitle: Text(user.email),
    );
  }
}
