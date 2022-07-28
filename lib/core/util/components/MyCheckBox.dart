import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  Color myColor;
   MyCheckBox({Key? key,required this.myColor}) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color? getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return (widget.myColor);
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

