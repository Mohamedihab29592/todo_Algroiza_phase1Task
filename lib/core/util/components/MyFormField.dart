import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final double radius;
   String ? title;
  final String hint;
  TextStyle? hintStyle;
  final TextInputType type;
  final VoidCallback? suffixIconPressed;
  final IconData? suffixIcon;
  final Widget? widget;
  TextEditingController ? controller;
  bool readonly = false;
  final dynamic validation;


  MyFormField(
      {Key? key,
      this.radius = 15,
      required this.type,
      required this.hint,
      this.suffixIcon,
      this.suffixIconPressed,
      this.widget,
       this.controller,
      required this.readonly,
      this.hintStyle,
       this.title,
       this.validation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(title!,style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[100]

          ),

          child :
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: readonly,
                      controller: controller,
                      keyboardType: type,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: hintStyle,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        suffixIcon: widget,
                      ),
                      validator: validation,
                    ),
                  ),
                ],
              ),


        ),
      ],
    );
  }
}
