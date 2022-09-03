// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chosen/components/chosen_checkbox.dart';
import 'package:chosen/components/chosen_container.dart';
import 'package:chosen/components/chosen_controller.dart';
import 'package:flutter/material.dart';

class ChosenButton<T> extends StatefulWidget {
  final String hintText;
  final List<ChosenMenuItem<T>> items;
  final dynamic value;
  final void Function(dynamic)? onChanged;
  final String? prefixText;
  final Widget? prefix;
  final bool isMultiSelection;
  final double buttonHeight;
  final double? dropdownMaxHeight;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final ChosenController? controller;

  const ChosenButton({
    Key? key,
    this.hintText = '',
    this.items = const [],
    this.value,
    this.onChanged,
    this.prefixText,
    this.prefix,
    this.isMultiSelection = false,
    this.buttonHeight = 40,
    this.dropdownMaxHeight = 400,
    this.enabledBorder,
    this.focusedBorder,
    this.disabledBorder,
    this.controller,
  }) : super(key: key);

  factory ChosenButton.singleSelection({
    String hintText = '',
    List<ChosenMenuItem<T>> items = const [],
    T? value,
    required void Function(T?)? onChanged,
    String? prefixText,
    Widget? prefix,
    double buttonHeight = 34,
    double? dropdownMaxHeight = 400,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    ChosenController? controller,
  }) {
    return ChosenButton(
      hintText: hintText,
      items: items,
      value: value,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value as T);
        }
      },
      prefixText: prefixText,
      prefix: prefix,
      buttonHeight: buttonHeight,
      dropdownMaxHeight: dropdownMaxHeight,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      controller: controller,
      isMultiSelection: false,
    );
  }

  factory ChosenButton.multiSelection({
    String hintText = '',
    List<ChosenMenuItem<T>> items = const [],
    List<T>? values,
    required void Function(List<T>?)? onChanged,
    String? prefixText,
    Widget? prefix,
    double buttonHeight = 34,
    double? dropdownMaxHeight = 400,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? disabledBorder,
    ChosenController? controller,
  }) {
    return ChosenButton(
      hintText: hintText,
      items: items,
      value: values,
      onChanged: (values) {
        if (onChanged != null) {
          onChanged(values as List<T>?);
        }
      },
      prefixText: prefixText,
      prefix: prefix,
      buttonHeight: buttonHeight,
      dropdownMaxHeight: dropdownMaxHeight,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      controller: controller,
      isMultiSelection: true,
    );
  }

  @override
  State<ChosenButton> createState() => _ChosenButtonState<T>();
}

class _ChosenButtonState<T> extends State<ChosenButton<T>> {
  late ChosenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ChosenController();
  }

  void onChanged(List<ChosenMenuItem<T>>? value) {
    if (!widget.isMultiSelection) {
      _controller.isOpened = false;
    }

    if (widget.onChanged != null && value != null) {
      final values =
          value.where((e) => e.value != null).map((e) => e.value!).toList();

      if (widget.isMultiSelection) {
        widget.onChanged!(values);
      } else if (values.isNotEmpty) {
        widget.onChanged!(values[0]);
      }
    }
  }

  String? getText() {
    List<ChosenMenuItem<T>> items = [];

    try {
      if (widget.isMultiSelection) {
        items = widget.items
            .where((e) => (widget.value! as List<T>).contains(e.value))
            .toList();
      } else {
        items = [
          widget.items.firstWhere((e) => (widget.value! as T) == e.value)
        ];
      }
    } catch (_) {}

    if (items.isEmpty) return null;

    return items.map((e) => e.label).toList().join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final hasBorder = widget.enabledBorder == null &&
        widget.focusedBorder == null &&
        widget.disabledBorder == null;
    List<T>? value;

    if (widget.value is T) {
      value = [widget.value];
    } else if (widget.value is List<T>?) {
      value = widget.value;
    }

    final child = _ChosenContent<T>(
      value: value,
      isMultiSelection: widget.isMultiSelection,
      onChanged: onChanged,
      items: widget.items,
      prefixText: widget.prefixText,
      prefix: widget.prefix,
    );

    if (hasBorder) {
      return ChosenContainer.border(
        context,
        hintText: widget.hintText,
        text: getText(),
        controller: _controller,
        buttonHeight: widget.buttonHeight,
        dropdownMaxHeight: widget.dropdownMaxHeight,
        child: child,
      );
    }

    return ChosenContainer(
      hintText: widget.hintText,
      text: getText(),
      controller: _controller,
      buttonHeight: widget.buttonHeight,
      dropdownMaxHeight: widget.dropdownMaxHeight,
      enabledBorder: widget.enabledBorder ?? InputBorder.none,
      focusedBorder: widget.focusedBorder ?? InputBorder.none,
      disabledBorder: widget.disabledBorder ?? InputBorder.none,
      child: child,
    );
  }
}

class ChosenMenuItem<T> {
  final String label;
  final T? value;
  final VoidCallback? onTap;
  final bool enabled;

  const ChosenMenuItem({
    required this.label,
    this.value,
    this.onTap,
    this.enabled = true,
  });
}

class _ChosenContent<T> extends StatefulWidget {
  final List<ChosenMenuItem<T>> items;
  final List<T>? value;
  final bool isMultiSelection;
  final String? prefixText;
  final Widget? prefix;
  final void Function(List<ChosenMenuItem<T>>?)? onChanged;

  const _ChosenContent({
    Key? key,
    this.items = const [],
    this.value,
    this.isMultiSelection = false,
    this.prefixText,
    this.prefix,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_ChosenContent> createState() => _ChosenContentState<T>();
}

class _ChosenContentState<T> extends State<_ChosenContent<T>> {
  List<ChosenMenuItem<T>> selected = [];

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      selected
          .addAll(widget.items.where((e) => widget.value!.contains(e.value)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.prefixText != null && widget.prefixText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.prefixText!,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontSize: 12,
                    color: const Color(0xff014C8B),
                  ),
            ),
          ),
        if (widget.prefix != null) widget.prefix!,
        ...widget.items.map((e) {
          return ChosenCheckbox(
            label: e.label,
            onChanged: (_) {
              if (e.onTap != null) {
                e.onTap!();
              }

              if (!selected.contains(e)) {
                setState(() {
                  if (!widget.isMultiSelection) {
                    selected.clear();
                  }

                  if (e.value != null) {
                    selected.add(e);
                  }
                });
              } else if (widget.isMultiSelection) {
                setState(() {
                  selected.remove(e);
                });
              }

              if (widget.onChanged != null) {
                widget.onChanged!(selected);
              }
            },
            value: selected.contains(e),
          );
        }).toList(),
      ],
    );
  }
}
