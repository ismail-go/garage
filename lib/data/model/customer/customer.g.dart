// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      name: json['name'] as String,
      surname: json['surname'] as String,
      tcNo: json['tc_no'] as String,
      taxNo: json['tax_no'] as String,
      telNo: json['tel_no'] as String,
      address: json['address'] as String,
      debit: (json['debit'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'tc_no': instance.tcNo,
      'tax_no': instance.taxNo,
      'tel_no': instance.telNo,
      'address': instance.address,
      'debit': instance.debit,
    };
