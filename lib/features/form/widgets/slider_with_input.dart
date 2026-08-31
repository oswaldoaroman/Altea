import 'package:flutter/material.dart';
import 'package:altea/core/theme/colors.dart';

// come kk

class SliderWithInput extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;
  final String? hint;

  const SliderWithInput({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.hint,
  });

  @override
  State<SliderWithInput> createState() => _SliderWithInputState();
}

class _SliderWithInputState extends State<SliderWithInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String get _hint => widget.hint ?? 'Ingresar ${widget.label.toLowerCase()}';

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _controller.text = widget.value.toInt().toString());
      }
    });
  }

  @override
  void didUpdateWidget(covariant SliderWithInput old) {
    super.didUpdateWidget(old);

    if (old.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value.toInt().toString();
    }
  }

  void _actualizarDesdeTexto(String texto) {
    final numero = double.tryParse(texto);
    if (numero == null) return;

    widget.onChanged(numero.clamp(widget.min, widget.max));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: 96,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: _actualizarDesdeTexto,
                style: const TextStyle(fontSize: 12.5),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _hint,
                  hintStyle: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.slate,
                  ),
                  suffixText: widget.suffix,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: AppColors.sky,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        Slider.adaptive(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          activeColor: AppColors.blue,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
