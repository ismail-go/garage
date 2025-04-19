// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkState _$WorkStateFromJson(Map<String, dynamic> json) => WorkState(
      state: $enumDecode(_$StateEnumMap, json['state']),
      time: WorkState._durationFromMilliseconds((json['time'] as num).toInt()),
    );

Map<String, dynamic> _$WorkStateToJson(WorkState instance) => <String, dynamic>{
      'state': _$StateEnumMap[instance.state]!,
      'time': WorkState._durationToMilliseconds(instance.time),
    };

const _$StateEnumMap = {
  State.registered: 'registered',
  State.working: 'working',
  State.testing: 'testing',
  State.done: 'done',
};
