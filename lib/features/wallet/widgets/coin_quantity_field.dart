import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/text_ext.dart';
import '../../../core/utils/form_validations.dart';
import '../../home/entities/coin_data.dart';
import '../../home/widgets/coin_icon.dart';
import 'coin_drop_down_button.dart';

class CoinQuantityField extends StatelessWidget {
  const CoinQuantityField({
    super.key,
    this.onChanged,
    this.textController,
    this.onCoinChange,
    required this.coin,
  });

  final CoinData coin;
  final TextEditingController? textController;
  final void Function(String)? onChanged;
  final void Function(CoinData coin)? onCoinChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: coin.id,
          child: CoinIcon(image: coin.image),
        ),
        onCoinChange == null //
            ? AppSizes.smallX
            : CoinDropDownButton(onSelected: onCoinChange!),
        AppSizes.normalX,
        Expanded(
          child: TextFormField(
            onChanged: onChanged,
            controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            validator: FormValidations.price,
            style: context.textTheme.titleLarge!.light,
            decoration: InputDecoration(
              suffixText: coin.symbol.toUpperCase(),
            ),
          ),
        ),
      ],
    );
  }
}
