import 'package:flutter/material.dart';


class MyTimePicker extends StatefulWidget {
  late final String? hint;
  final String title;
  TextEditingController ? controller;
  TextStyle? hintStyle;



  MyTimePicker(
      {Key? key, this.hint, required this.title,  this.controller, this.hintStyle })
      : super(key: key);

  @override
  _MyTimePickerState createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey[100]),
          height: 60,
          width: double.infinity,
          child: TextFormField(
            keyboardType: TextInputType.datetime,
            readOnly: true,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: widget.hintStyle,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed:() {showTime();}
              ),
            ),
            onTap: (){
              showTime();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return " time can not be empty";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
  void showTime() async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now(),)
        .then((dynamic value) {
          setState(() {
        widget.controller!.text = value.format(context);
      });
    });
  }


}
