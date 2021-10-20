//
//  VDUploadResultDO.m
//  WDNetworkingDemo
//
//  Created by wtwo on 16/8/25.
//  Copyright © 2016年 yangxin02. All rights reserved.
//

#import "VDUploadResultDO.h"


@implementation VDUploadVideosDO

@end

@implementation VDUploadResultDO

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code":       @"status.code",
             @"message":    @"status.message",
             @"key":        @"result.key",
             @"url":        @"result.url",
             @"state":      @"result.state",
             @"uploadId":   @"result.uploadId",
             @"innerUrl":   @"result.innerUrl",
             @"videoId":    @"result.id",
             @"thumbnail":  @"result.thumbnail",
             @"videos":     @"result.videos",
             @"gifUrl":     @"result.gifUrl",
             
             @"originResult": @"result",
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.url && ![self.url hasPrefix:@"http"]) {
        self.url = [@"https:" stringByAppendingString:self.url];
    }
    
    if (self.gifUrl && ![self.gifUrl hasPrefix:@"http"]) {
        self.gifUrl = [@"https:" stringByAppendingString:self.gifUrl];
    }
    
    return YES;
}

@end
