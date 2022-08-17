class RepeatModel {
  final String repeat;
  final int hours;


  RepeatModel({
    required this.repeat,
    required this.hours,

  });

  factory RepeatModel.fromJson(Map<String, dynamic> json) {
    return RepeatModel(
      repeat:  json['repeat'] ,
      hours:  json['hours'] ,
    );
  }
}