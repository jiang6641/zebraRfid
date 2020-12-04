package com.hone.zebra_rfid;


import com.zebra.rfid.api3.ACCESS_OPERATION_STATUS;

public class Base {
    public static class ErrorResult {

        public static ErrorResult error(String errorMessage, int code) {
            ErrorResult result=new ErrorResult();
            result.errorMessage=errorMessage;
            result.code=code;
             return result;

        }

        public  static ErrorResult error(String errorMessage) {
            ErrorResult result=new ErrorResult();
            result.errorMessage=errorMessage;
            return result;
        }

        int code = -1;
        String errorMessage = "";
    }

    public  static  class RfidEngineEvents{
        static String Error = "Error";
        static String ReadRfid = "ReadRfid";
        static String ConnectionStatus = "ConnectionStatus";
    }


    enum ConnectionStatus {
        ///未连接
        UnConnection,

        ///连接完成
        ConnectionRealy,

        ///连接出错
        ConnectionError,
    }



    public static class RfidData{
        ///标签id
        public String tagID;

        public short antennaID;
        //信号峰值
        public short peakRSSI;
 
        // public String tagDetails; 
        ///操作状态
        public ACCESS_OPERATION_STATUS opStatus;

        ///相对距离
        public short relativeDistance;

        ///存储数据
        public String memoryBankData;

        ///永久锁定数据
        public String lockData;
        ///分配大小
        public int allocatedSize;

        public int count=0;
    }
}
