import 'package:flutter/material.dart';

class ChosenCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsets padding;

  const ChosenCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AbsorbPointer(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: value,
                      onChanged: (newValue) => onChanged(newValue!),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xff014C8B);
                        } else if (states.contains(MaterialState.disabled)) {
                          return const Color(0xffB8BECD);
                        }

                        return const Color(0xffA1A9BA);
                      }),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xffA1A9BA),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: const Color(0xff014C8B),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
