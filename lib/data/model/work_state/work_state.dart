import 'package:json_annotation/json_annotation.dart';

part 'work_state.g.dart';

@JsonSerializable()
class WorkState {
  State state;

  @JsonKey(name: 'time', fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
  DateTime time;

  WorkState({required this.state, required this.time});

  factory WorkState.fromJson(Map<String, dynamic> json) => _$WorkStateFromJson(json);

  Map<String, dynamic> toJson() => _$WorkStateToJson(this);

  static DateTime _durationFromMilliseconds(int milliseconds) => DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static int _durationToMilliseconds(DateTime time) => time.millisecondsSinceEpoch;
}

enum State {
  registered,
  working,
  testing,
  done,
}
