import 'package:flutter/material.dart';

import 'preference_service.dart';

class TextFieldPreference extends StatefulWidget {
  final String label;
  final String localKey;
  final String defaultVal;
  final EdgeInsets padding;
  final bool autofocus;
  final int maxLines;
  final bool obscureText;
  final String hintText;
  final TextStyle style;
  final TextInputType keyboardType;
  final TextStyle labelStyle;
  final InputDecoration decoration;

  final Function onChange;
  final Function validator;

  final bool disabled;

  const TextFieldPreference(
    this.label,
    this.localKey, {
    this.defaultVal,
    this.onChange,
    this.validator,
    this.padding,
    this.obscureText = false,
    this.autofocus = false,
    this.hintText = '',
    this.maxLines = 1,
    this.style,
    this.keyboardType,
    this.labelStyle,
    this.decoration,
    this.disabled = false,
  });

  @override
  _TextFieldPreferenceState createState() => _TextFieldPreferenceState();
}

class _TextFieldPreferenceState extends State<TextFieldPreference> {
  TextEditingController controller = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    final service = PrefService.of(context);

    if (service.getString(widget.localKey) == null &&
        widget.defaultVal != null) {
      service.setString(widget.localKey, widget.defaultVal);
    }

    if (!_initialized) {
      controller.text =
          service.getString(widget.localKey) ?? widget.defaultVal ?? '';
      _initialized = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Form(
        child: Builder(
          builder: (BuildContext context) => TextFormField(
            decoration: widget.decoration ??
                InputDecoration(
                  hintText: widget.hintText,
                  labelText: widget.label,
                  labelStyle: widget.labelStyle,
                  border: OutlineInputBorder(),
                ),
            controller: controller,
            onChanged: (val) {
              if (Form.of(context).validate()) {
                if (widget.onChange != null) {
                  val = widget.onChange(val) ?? val;
                }
                PrefService.of(context).setString(widget.localKey, val);
              }
            },
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            style: widget.style,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            validator: widget.validator,
            enabled: !widget.disabled,
          ),
        ),
      ),
    );
  }
}
