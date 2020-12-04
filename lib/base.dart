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

  ///读取rfid标签回调
  ReadRfidCallback readRfidCallback;

  ///连接状态
  ConnectionStatusCallback connectionStatusCallback;

  ///异常错误回调
  ErrorCallback errorCallback;

  // ignore: public_member_api_docs
  void process(String eventName, Map<String, dynamic> map) {
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
        errorCallback.call(ss);
        break;
      case 'ConnectionStatus':
        ReaderConnectionStatus status =
            ReaderConnectionStatus.values[map["status"] as int];
        connectionStatusCallback.call(status);
        break;
    }
  }
}

enum ReaderConnectionStatus {
  ///未连接
  UnConnection,

  ///连接完成
  ConnectionRealy,

  ///连接出错
  ConnectionError,
}

///标签数据
@JsonSerializable()
class RfidData {
  RfidData();

  ///标签id
  String tagID;

  int antennaID;
  //信号峰值
  int peakRSSI;

  // public String tagDetails;
  ///操作状态
  // ACCESS_OPERATION_STATUS opStatus;

  ///相对距离
  int relativeDistance;

  ///识别次数
  int count = 0;

  ///存储数据
  String memoryBankData;

  ///永久锁定数据
  String lockData;

  ///分配大小
  int allocatedSize;

  factory RfidData.fromJson(Map<dynamic, dynamic> json) =>
      _$RfidDataFromJson(json);
  Map<String, dynamic> toJson() => _$RfidDataToJson(this);
}

@JsonSerializable()
class ErrorResult {
  ErrorResult();

  int code = -1;
  String errorMessage = "";

  factory ErrorResult.fromJson(Map<String, dynamic> json) =>
      _$ErrorResultFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResultToJson(this);
}
