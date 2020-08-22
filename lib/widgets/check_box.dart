import 'package:flutter/material.dart';

class CheckBox extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool value;
  final EdgeInsets padding;
  final String label;

  const CheckBox(
      {Key key,
        @required this.value,
        @required this.onChanged,
        @required this.label,
        @required this.padding})
      : assert(value != null),
        assert(onChanged != null),
        assert(label != null),
        assert(padding != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              key: key,
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}