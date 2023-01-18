import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

typedef ErrorCallback = void Function(ErrorResult err);
typedef ReadRfidCallback = void Function(List<RfidData> datas);
typedef ConnectionStatusCallback = void Function(ReaderConnectionStatus status);

class ZebraEngineEventHandler {
  ZebraEngineEventHandler(
      {this.readRfidCallback,
      this.errorCallback,
      this.connectionStatusCallback});

  ///Read rfid tag callback
  ReadRfidCallback? readRfidCallback;

  ///Connection Status
  ConnectionStatusCallback? connectionStatusCallback;

  ///Exception error callback
  ErrorCallback? errorCallback;

  // ignore: public_member_api_docs
  void process(String? eventName, Map<String, dynamic> map) {
    switch (eventName) {
      case 'ReadRfid':
        List<dynamic> rfidDatas = map["datas"];
        List<RfidData> list = [];
        for (var i = 0; i < rfidDatas.length; i++) {
          list.add(RfidData.fromJson(Map<String, dynamic>.from(rfidDatas[i])));
        }
        readRfidCallback?.call(list);
        break;
      case 'Error':
        var ss = ErrorResult.fromJson(map);
        errorCallback!.call(ss);
        break;
      case 'ConnectionStatus':
        ReaderConnectionStatus status =
            ReaderConnectionStatus.values[map["status"] as int];
        connectionStatusCallback!.call(status);
        break;
    }
  }
}

enum ReaderConnectionStatus {
  ///not connected
  UnConnection,

  ///The connection is complete
  ConnectionReally,

  /// Connection error
  ConnectionError,
}

/// label data
@JsonSerializable()
class RfidData {
  RfidData();

  ///label id
  String? tagID;

  int? antennaID;
  //signal peak
  int? peakRSSI;

  // public String tagDetails;
  ///Operation status
  // ACCESS_OPERATION_STATUS opStatus;

  ///relative distance
  int? relativeDistance;

  ///Recognition times
  int? count = 0;

  ///Storing data
  String? memoryBankData;

  ///Permanently lock the data
  String? lockData;

  ///allocation size
  int? allocatedSize;

  factory RfidData.fromJson(Map<dynamic, dynamic> json) =>
      _$RfidDataFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RfidDataToJson(this);
}

@JsonSerializable()
class ErrorResult {
  ErrorResult();

  int? code = -1;
  String? errorMessage = "";

  factory ErrorResult.fromJson(Map<String, dynamic> json) =>
      _$ErrorResultFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResultToJson(this);
}
