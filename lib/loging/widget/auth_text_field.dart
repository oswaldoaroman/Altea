import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';


class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool esPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.esPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.ink)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.esPassword && _oculto,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.slate, fontSize: 13),
            filled: true,
            fillColor: AppColors.sky,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            suffixIcon: widget.esPassword
                ? IconButton(
                    icon: Icon(_oculto ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 19, color: AppColors.slate),
                    onPressed: () => setState(() => _oculto = !_oculto),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
