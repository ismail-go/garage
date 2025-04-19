import 'package:json_annotation/json_annotation.dart';

part 'work_state.g.dart';

@JsonSerializable()
class WorkState {
  State state;

  @JsonKey(name: 'time', fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
  Duration time;

  WorkState({required this.state, required this.time});

  factory WorkState.fromJson(Map<String, dynamic> json) => _$WorkStateFromJson(json);

  Map<String, dynamic> toJson() => _$WorkStateToJson(this);

  static Duration _durationFromMilliseconds(int milliseconds) => Duration(milliseconds: milliseconds);

  static int _durationToMilliseconds(Duration duration) => duration.inMilliseconds;
}

enum State {
  registered,
  working,
  testing,
  done,
}
