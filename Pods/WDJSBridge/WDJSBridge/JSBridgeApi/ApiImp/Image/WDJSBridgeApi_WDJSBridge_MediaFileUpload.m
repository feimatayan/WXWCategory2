//
// Created by 石恒智 on 2018/12/9.
// Copyright (c) 2018 weidian. All rights reserved.
//

#import "WDJSBridgeApi_WDJSBridge_MediaFileUpload.h"
#import "NSObject+YYModel.h"
#import "UIImage+VDCompress.h"
#import "VDFileUploader.h"
#import "VDUploadResultDO.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@implementation WDJSBridgeApiMediaFileUploadCompressDO

@end

@implementation WDJSBridgeApiMediaFileUploadControlDO

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileType = @"image";
        _unadjust = NO;
        _isPrivate = NO;
    }

    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"isPrivate": @"private"
    };
}
@end

@implementation WDJSBridgeApiMediaFileUploadChooseDO

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"isCamera": @"camera",
            @"ratio": @"crop.ratio"
    };
}
@end


@implementation WDJSBridgeApiMediaFileUploadDataDO

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"base64DataString": @"base64"
    };
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
            @"localPathUrlArray": [NSString class]
    };
}
@end

@interface WDJSBridgeApi_WDJSBridge_MediaFileUpload ()
@end

@implementation WDJSBridgeApi_WDJSBridge_MediaFileUpload


- (void)callApiWithContextInfo:(NSDictionary<NSString *, id> *)info callback:(WDJSBridgeHandlerCallback)callback {
    WDJSBridgeApiMediaFileUploadCompressDO *compressDO = [WDJSBridgeApiMediaFileUploadCompressDO yy_modelWithDictionary:self.params[@"compress"]];
    WDJSBridgeApiMediaFileUploadControlDO *controlDO = [WDJSBridgeApiMediaFileUploadControlDO yy_modelWithDictionary:self.params[@"control"]];;
    WDJSBridgeApiMediaFileUploadDataDO *dataDO = [WDJSBridgeApiMediaFileUploadDataDO yy_modelWithDictionary:self.params[@"data"]];
    WDJSBridgeApiMediaFileUploadChooseDO *chooseDO = [WDJSBridgeApiMediaFileUploadChooseDO yy_modelWithDictionary:self.params[@"choose"]];
    if (![controlDO.scope length]) {
        callback(WDJSBridgeHandlerResponseCodeFailure, @{@"result": [self errorResponseWithCode:@"-500001" message:@"scope can not be null"]});
        return;
    }

    if (dataDO.base64DataString) {
        [self.jsbridge callJSBridgeWithModule:@"WDJSBridge"
                                   identifier:@"uploadImage"
                                        param:@{
                                                               @"control": self.params[@"control"] ?: @"",
                                                               @"compress": self.params[@"compress"] ?: @"",
                                                               @"data": @{
                                                                       @"base64": dataDO.base64DataString ?: @""
                                                               }
                                                       }
                                   completion:^(NSDictionary *result, NSError *error) {
                                                      WDJSBridgeHandlerResponseCode responseCode = WDJSBridgeHandlerResponseCodeSuccess;
                                                      if (result[kWDJSBridgeErrMsgKey]) {
                                                          NSNumber *errorCode = result[kWDJSBridgeErrMsgKey][@"code"];
                                                          responseCode = errorCode.integerValue;
                                                      }
                                                      callback(responseCode, result);
                                                  }];
        return;
    }

    [self.jsbridge callJSBridgeWithModule:@"WDJSBridge"
                               identifier:@"chooseImage"
                                    param:@{
                                                           @"type": @(chooseDO.isCamera),
                                                           @"count": @(chooseDO.limit),
                                                           @"ratio": @(chooseDO.ratio)
                                                   }
                               completion:^(NSDictionary *result, NSError *error) {
                                                  NSArray<NSString *> *images = result[@"images"];
                                                  if (![images count]) {
                                                      WDJSBridgeHandlerResponseCode responseCode = WDJSBridgeHandlerResponseCodeSuccess;
                                                      if (result[kWDJSBridgeErrMsgKey]) {
                                                          NSNumber *errorCode = result[kWDJSBridgeErrMsgKey][@"code"];
                                                          responseCode = errorCode.integerValue;
                                                      }
                                                      callback(responseCode, result);
                                                      return;
                                                  }
                                                  [self.jsbridge callJSBridgeWithModule:@"WDJSBridge"
                                                                             identifier:@"uploadImage"
                                                                                  param:@{
                                                                                                         @"control": self.params[@"control"] ?: @"",
                                                                                                         @"compress": self.params[@"compress"] ?: @"",
                                                                                                         @"data": @{
                                                                                                                 @"images": images
                                                                                                         }
                                                                                                 } completion:^(NSDictionary *result, NSError *error) {
                                                              WDJSBridgeHandlerResponseCode responseCode = WDJSBridgeHandlerResponseCodeSuccess;
                                                              if (result[kWDJSBridgeErrMsgKey]) {
                                                                  NSNumber *errorCode = result[kWDJSBridgeErrMsgKey][@"code"];
                                                                  responseCode = errorCode.integerValue;
                                                              }
                                                              callback(responseCode, result ?: @{});
                                                          }];
                                              }];
}

- (NSDictionary *)errorResponseWithCode:(NSString *)code message:(NSString *)message {
    NSMutableDictionary *res = @{}.mutableCopy;
    if (code) {
        res[@"code"] = code;
    }
    if (message) {
        res[@"message"] = message;
    }
    return @{@"result": @[res.copy ?: @{}]};
}
@end
