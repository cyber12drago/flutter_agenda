import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  final String data;

  const FormLabel(
      this.data
      , {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Text(
        data,
        style: TextStyle(fontSize: 12.0, color: Theme.of(context).colorScheme.primary),
        textAlign: TextAlign.start,
      ),
    );
  }
}