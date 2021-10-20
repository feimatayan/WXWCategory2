//
//  VDQueryVideoMission.m
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/8/31.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDQueryVideoMission.h"
#import "VDFileUploador.h"
#import "VDUploadResultDO.h"
#import "VDFileUploadConstant.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/WDNErrorDO.h>
#import <WDNetwork-Base/WDNetworkMacro.h>
#import <WDNetwork-Base/WDNetworkDataTask.h>

#import <AFNetworking/AFHTTPSessionManager.h>
#import <YYModel/YYModel.h>


@implementation VDQueryVideoMission

- (NSURLRequest *)requestMayError:(WDNErrorDO *__autoreleasing *)error {
    NSString *scope = self.scope;
    NSString *videoId = self.videoId;

    if (videoId.length == 0) {
        *error = [WDNErrorDO errorWithCode:VDUploadParamError msg:@"videoId is nil"];
        return nil;
    }
    
    NSString *host = [VDFileUploador host];
    NSString *api = API_UPLOAD_VIDEO_Q;
    api = [api stringByReplacingOccurrencesOfString:@"<scope>" withString:scope];
    api = [api stringByReplacingOccurrencesOfString:@"<id>" withString:videoId];
    
    NSString *url = [NSString stringWithFormat:@"https://%@/%@", host, api];
    
    AFHTTPRequestSerializer *requestSerializer = wdn_session_manager().requestSerializer;
    NSError *originError = nil;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET"
                                                              URLString:url
                                                             parameters:nil
                                                                  error:&originError];
    if (request) {
        request.HTTPShouldHandleCookies = NO;
        request.timeoutInterval = 30;
        
        [request setValue:@"ios.weidian.com" forHTTPHeaderField:@"Origin"];
        [request setValue:@"https://ios.weidian.com" forHTTPHeaderField:@"referer"];
        [request setValue:[VDFileUploador UA] forHTTPHeaderField:@"User-Agent"];
        [request setValue:host forHTTPHeaderField:@"Host"];
    } else {
        *error = [WDNErrorDO httpCommonErrorWithError:originError];
    }
    
    return request;
}

@end
