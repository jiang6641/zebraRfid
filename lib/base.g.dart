// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RfidData _$RfidDataFromJson(Map<String, dynamic> json) {
  return RfidData()
    ..tagID = json['tagID'] as String?
    ..antennaID = json['antennaID'] as int?
    ..peakRSSI = json['peakRSSI'] as int?
    ..relativeDistance = json['relativeDistance'] as int?
    ..count = json['count'] as int?
    ..memoryBankData = json['memoryBankData'] as String?
    ..lockData = json['lockData'] as String?
    ..allocatedSize = json['allocatedSize'] as int?;
}

Map<String, dynamic> _$RfidDataToJson(RfidData instance) => <String, dynamic>{
      'tagID': instance.tagID,
      'antennaID': instance.antennaID,
      'peakRSSI': instance.peakRSSI,
      'relativeDistance': instance.relativeDistance,
      'count': instance.count,
      'memoryBankData': instance.memoryBankData,
      'lockData': instance.lockData,
      'allocatedSize': instance.allocatedSize,
    };

ErrorResult _$ErrorResultFromJson(Map<String, dynamic> json) {
  return ErrorResult()
    ..code = json['code'] as int?
    ..errorMessage = json['errorMessage'] as String?;
}

Map<String, dynamic> _$ErrorResultToJson(ErrorResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errorMessage': instance.errorMessage,
    };
