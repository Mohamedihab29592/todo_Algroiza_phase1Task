import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  final String? hint;
  final String title;
  TextEditingController controller;

  MyDatePicker(
      {Key? key, this.hint, required this.title, required this.controller})
      : super(key: key);

  @override
  State<MyDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<MyDatePicker> {
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
              hintText: '2022-01-01',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: () {
                    showDate();
                  }),
            ),
            onTap: () {
              showDate();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return " Date can not be empty";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void showDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    widget.controller.text = date.toString().substring(0, 10);




  }
}
