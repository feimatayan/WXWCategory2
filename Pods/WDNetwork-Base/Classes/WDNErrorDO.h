//
//  WDNStatusDO.h
//  WDNetworkingDemo
//
//  Created by yangxin02 on 1/20/16.
//  Copyright © 2016 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WDNErrorType) {
    WDNNetowrkSuccess = 0,

    WDNUnKnowError = -10000,
    //客户端错误
    WDNClientParamSerialError = -10001,
    WDNClientParamAESError = -10002,
    WDNClientParamError = -10003,
    WDNClientURLillegal = -10004,
    WDNetworkCancel = -10101,
    WDNAPINeedLoginInfo = -10201,
    WDNLoginCancel = -10202,

    //Response
    WDNResponseDataNil = -20001,
    WDNResponseDataAESError = -20002,
    WDNResponseDataSerialError = -20003,
    WDNResponseDataFormatError = -20004,
    WDNResponseHeaderMissInfo = -21001,
    WDNResponseCRC32CheckError = -22001,
    WDNResponseMD5CheckError = -22002,

    //App Server
    WDNServerReturnCode = -30001,
    WDNServerDecyptError = -30002,
    WDNServerCertifyNoPass = -31001,
    WDNServerLoginError = -31002,

    // 一般网路错误
//    -40001, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet,//1.4.7开始废弃
//    -40003, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost,          //1.4.7开始废弃

    WDNHttpCommonError = -40000,
    WDNHttpTimeOut = -40002,
    WDNHttpBadURL = -40004,
    WDNHttpBadServerResponse = -40005,

    WDNHttpNoNetwork = -40006,                  //没有网络;
    WDNHttpCannotFindHost = -40007,             //主机找不到, 可能是DNS问题;
    WDNHttpErrorCannotConnectToHost = -40008,   //主机关闭或者端口不对;
    WDNHttpCallIsActive = -40009,               //正在通话;
    WDNHttpNetworkConnectionLost = -40010,      //网络被中断;
    
    
    //图片、视频上传的错误码
    WDNFileUploadErrorTypeNotExist = -50000,
    WDNFileUploadErrorTypeTransformFailed,
    WDNFileUploadErrorTypeTooLarge,
    WDNFileUploadErrorTypeServerReturnDataError,
    
    VDUploadParamError = -60000,
};

@interface WDNErrorDO : NSObject

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) WDNErrorType code;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) NSInteger serverCode;
@property (nonatomic, strong, readonly) NSError *originError;

@property (nonatomic, assign) NSInteger subCode;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, strong) id resultData;

@property (nonatomic, copy) NSString *cuid;

+ (instancetype)errorWithCode:(WDNErrorType)code msg:(NSString *)msg;
+ (instancetype)serverErrorWithCode:(NSInteger)code msg:(NSString *)msg;
+ (instancetype)httpCommonErrorWithError:(NSError *)error;

/**
 *  https访问时，发生错误时需要降级到http
 *
 *  @param error NSError
 *
 *  @return 是否需要使用http重发
 */
+ (BOOL)needReSend4HttpsWithError:(NSError *)error;

@end
