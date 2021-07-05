import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zebra_rfid/base.dart';
import 'package:zebra_rfid/zebra_rfid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Map<String, RfidData> rfidDatas = {};
  ReaderConnectionStatus connectionStatus = ReaderConnectionStatus.UnConnection;
  addDatas(List<RfidData> datas) async {
    for (var item in datas) {
      var data = rfidDatas[item.tagID];
      if (data != null) {
        data.count++;
        data.peakRSSI = item.peakRSSI;
        data.relativeDistance = item.relativeDistance;
      } else
        rfidDatas.addAll({item.tagID: item});
    }
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ZebraRfid.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Status  ${connectionStatus.index}'),
      ),
      body: Center(
          child: Column(
        children: [
          Text('Running on: $_platformVersion\n'),
          Text('count:${rfidDatas.length.toString()}'),
          Row(children: [
            MaterialButton(
              onPressed: () async {
                ZebraRfid.setEventHandler(ZebraEngineEventHandler(
                  readRfidCallback: (datas) async {
                    addDatas(datas);
                  },
                  errorCallback: (err) {
                    ZebraRfid.toast(err.errorMessage);
                  },
                  connectionStatusCallback: (status) {
                    setState(() {
                      connectionStatus = status;
                    });
                  },
                ));
                ZebraRfid.connect();
              },
              child: Text("read"),
            ),
            MaterialButton(
              onPressed: () async {
                setState(() {
                  rfidDatas = {};
                });
              },
              child: Text("clear"),
            ),
            MaterialButton(
              onPressed: () async {
                ZebraRfid.disconnect();
              },
              child: Text("stop"),
            ),
          ]),
          Expanded(
              child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var key = rfidDatas.keys.toList()[index];
                return ListTile(title: Text(rfidDatas[key].tagID));
              },
              itemCount: rfidDatas.length,
            ),
          ))
        ],
      )),
    ));
  }
}
