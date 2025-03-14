// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../pref.dart';
import 'dialog.dart';
import 'dialog_button.dart';
import 'radio.dart';
import 'service/pref_service.dart';

class PrefChoice<T> extends StatefulWidget {
  const PrefChoice({
    Key? key,
    this.title,
    required this.pref,
    this.subtitle,
    required this.items,
    this.onChange,
    this.disabled = false,
    this.cancel,
    this.submit,
    this.radioFirst = true,
  }) : super(key: key);

  final Widget? title;

  final Widget? subtitle;

  final String pref;

  final List<DropdownMenuItem<T>> items;

  final ValueChanged<T>? onChange;

  final bool disabled;

  final Widget? submit;

  final Widget? cancel;

  final bool radioFirst;

  @override
  _PrefChoiceState<T> createState() => _PrefChoiceState<T>();
}

class _PrefChoiceState<T> extends State<PrefChoice<T>> {
  @override
  void didChangeDependencies() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    PrefService.of(context).removeKeyListener(widget.pref, _onNotify);
    super.deactivate();
  }

  @override
  void reassemble() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.reassemble();
  }

  void _onNotify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    T? value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }

    // check if the value is present in the list of choices
    Widget? selected;
    for (final item in widget.items) {
      if (item.value == value) {
        selected = item.child;
      }
    }

    if (selected == null) {
      value = null;
    }

    return PrefDialogButton(
      title: widget.title,
      subtitle: widget.subtitle ?? selected,
      dialog: PrefDialog(
        children: widget.items
            .map<PrefRadio<T?>>(
              (e) => PrefRadio<T?>(
                title: e.child,
                value: e.value,
                disabled: widget.disabled,
                pref: widget.pref,
                radioFirst: widget.radioFirst,
              ),
            )
            .toList(),
        title: widget.title,
        onlySaveOnSubmit: true,
        dismissOnChange: widget.submit == null,
        cancel: widget.cancel,
        submit: widget.submit,
      ),
    );
  }
}
