//
// Created by weidian2015090112 on 2018/8/29.
// Copyright (c) 2018 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WDNErrorDO;

@protocol VDUploadMissionProtocol <NSObject>

@required

- (NSURLRequest *)requestMayError:(WDNErrorDO **)error;

- (void)upload;
- (void)reload;

- (void)query;

- (void)cancel;

@end
