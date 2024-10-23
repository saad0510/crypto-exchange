import 'package:flutter/material.dart';

import '../../../app/sizes.dart';
import '../../../core/extensions/context_ext.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.textCapitalization = TextCapitalization.none,
    this.obscure = false,
    this.autofocus = false,
    this.initialValue = '',
    this.validator,
    this.keyboardType,
    required this.onSubmit,
    this.onChange,
  });

  final String initialValue;
  final String label;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final void Function(String) onSubmit;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: context.textTheme.bodyLarge,
        ),
        AppSizes.normalY,
        TextFormField(
          initialValue: widget.initialValue,
          onChanged: widget.onChange,
          autofocus: widget.autofocus,
          obscureText: widget.obscure && show,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          style: context.textTheme.bodyMedium?.copyWith(
            letterSpacing: widget.obscure && show ? 3 : null,
          ),
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          onSaved: (x) => widget.onSubmit(x?.trim() ?? ''),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: !widget.obscure
                ? null
                : IconButton(
                    splashRadius: 1,
                    icon: Icon(
                      show //
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => show = !show),
                  ),
          ),
        ),
      ],
    );
  }
}
