//
//  VDCompressUT.m
//  VDCompress
//
//  Created by weidian2015090112 on 2018/10/8.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDCompressUT.h"

#import <objc/runtime.h>
#import <objc/message.h>


#define kUTEventID      @"3120"
#define kUTPageName     @"img_compress"


@implementation VDCompressUTDO

@end


@implementation VDCompressUT

+ (void)vdUT_success:(BOOL)success
                time:(double)time
                args:(VDCompressUTDO *)args
{
    NSMutableDictionary *_args = [NSMutableDictionary dictionary];
    float ratio = 0;
    if (args) {
        _args[@"sourceFileSize"] = [NSString stringWithFormat:@"%ld", (long)args.sourceFileSize];
        _args[@"compressFileSize"] = [NSString stringWithFormat:@"%ld", (long)args.compressFileSize];
        _args[@"sourceImgSize"] = [NSString stringWithFormat:@"[%.0f, %.0f]", args.sourceImgSize.width, args.sourceImgSize.height];
        _args[@"compressImgSize"] = [NSString stringWithFormat:@"[%.0f, %.0f]", args.compressImgSize.width, args.compressImgSize.height];
        _args[@"compressOptions"] = [NSString stringWithFormat:@"maxFileSize=%ld, maxWidth=%.0f, maxHeight=%.0f, quality=%.2f", (long)args.maxFileSize, args.maxWidth, args.maxHeight, args.quality];
        
        if (args.sourceFileSize > 0) {
            ratio = args.compressFileSize * 1.0 / args.sourceFileSize;
        }
    }
    
    [self commitWitharg1:success ? @"1" : @"0"
                    arg2:[NSString stringWithFormat:@"%.0f", time]
                    arg3:[NSString stringWithFormat:@"%.3f", ratio]
                    args:_args
               isSuccess:success];
}

+ (void)commitWitharg1:(NSString *)arg1
                  arg2:(NSString *)arg2
                  arg3:(NSString *)arg3
                  args:(NSDictionary *)args
             isSuccess:(BOOL)isSuccess
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        Class utClass = NSClassFromString(@"WDUT");
        if (!utClass) {
            utClass = NSClassFromString(@"WDWT");
        }
        SEL utSelector = @selector(commitEvent:pageName:arg1:arg2:arg3:args:isSuccess:);
        if (utClass && [utClass respondsToSelector:utSelector]) {
            ((void (*)(id, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, NSDictionary *, BOOL)) objc_msgSend)
            (utClass, utSelector, kUTEventID, kUTPageName, arg1, arg2, arg3, args, isSuccess);
        }
    });
}

- (void)commitEvent:(NSString *)commitEvent
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
          isSuccess:(BOOL)isSuccess
{
    // do nothing
}

@end
