//
//  VDUploadUT.m
//  AFNetworking
//
//  Created by weidian2015090112 on 2018/9/18.
//

#import "VDUploadUT.h"
#import "VDUploadResultDO.h"

#import <WDNetwork-Base/WDNErrorDO.h>

#import <objc/message.h>


#define kVDUploadEventId    @"3220"
#define kVDUploadPageName   @"WDUpload"


@implementation VDUploadUT

+ (NSString *)getCuid {
    Class utClass = NSClassFromString(@"WDUT");
    if (!utClass) {
        utClass = NSClassFromString(@"WDWT");
    }
    SEL utSelector = @selector(getCuid);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        return ((NSString * (*)(id, SEL)) objc_msgSend)(utClass, utSelector);
    }
    
    return nil;
}

+ (void)VDUTDirect:(NSMutableDictionary *)args
            result:(VDUploadResultDO *)result
             error:(WDNErrorDO *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *uploadSuccess = @"0";
        NSString *statusCode = @"";
        if (result) {
            if (result.code == 100 || result.code == 200) {
                uploadSuccess = @"1";
            }
            
            statusCode = [NSString stringWithFormat:@"%ld", (long)result.code];

            args[kVDUStatusMessage] = result.message ?: @"";
            args[kVDUStatusResultState] = [NSString stringWithFormat:@"%ld", (long)result.state];
            args[kVDUKey] = result.key ?: @"";
        }
        
        if (error) {
            if (error.serverCode > 0) {
                statusCode = [NSString stringWithFormat:@"%ld", (long)error.serverCode];
            } else {
                statusCode = [NSString stringWithFormat:@"%ld", (long)error.code];
            }
            
            
            args[kVDUStatusMessage] = error.message ?: @"";
            
            if (error.originError) {
                NSError *originError = error.originError;
                args[@"ios_error_code"] = [NSString stringWithFormat:@"%ld", (long)originError.code];
                args[@"ios_error_msg"] = originError.domain ?: @"";
            }
        }
        
        args[@"sdk_v"] = @"1.0";
        
        NSDictionary *argsDict = [args copy];
        [argsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:NSString.class]) {
                NSString *value = (NSString *)obj;
                if (value.length == 0) {
                    [args removeObjectForKey:key];
                }
            }
        }];
        
        VDUploadCommitEvent_PageName_Arg1_Arg2_Arg3_Args(kVDUploadEventId,
                                                         kVDUploadPageName,
                                                         uploadSuccess,
                                                         @"DIRECT",
                                                         statusCode,
                                                         args);
    });
}

+ (void)VDUTChunk:(NSMutableDictionary *)args
           result:(VDUploadResultDO *)result
            error:(WDNErrorDO *)error
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *uploadSuccess = @"0";
        NSString *statusCode = @"";
        if (result) {
            if (result.code == 100 || result.code == 200) {
                uploadSuccess = @"1";
            }
            
            statusCode = [NSString stringWithFormat:@"%ld", (long)result.code];
            
            args[kVDUStatusMessage] = result.message ?: @"";
            args[kVDUStatusResultState] = [NSString stringWithFormat:@"%ld", (long)result.state];
            args[kVDUKey] = result.key ?: @"";
        }
        
        if (error) {
            if (error.serverCode > 0) {
                statusCode = [NSString stringWithFormat:@"%ld", (long)error.serverCode];
            } else {
                statusCode = [NSString stringWithFormat:@"%ld", (long)error.code];
            }
            
            args[kVDUStatusMessage] = error.message ?: @"";
            
            if (error.originError) {
                NSString *desc = @"Desc";
                NSString *descriptionKey = error.originError.userInfo[NSLocalizedDescriptionKey];
                NSString *failureReasonKey = error.originError.userInfo[NSLocalizedFailureReasonErrorKey];
                
                if ([descriptionKey isKindOfClass:[NSString class]] && descriptionKey.length > 0) {
                    desc = [desc stringByAppendingString:@", "];
                    desc = [desc stringByAppendingString:descriptionKey];
                }
                
                if ([failureReasonKey isKindOfClass:[NSString class]] && failureReasonKey.length > 0) {
                    desc = [desc stringByAppendingString:@", "];
                    desc = [desc stringByAppendingString:failureReasonKey];
                }
                
                args[kVDUStatusDesc] = desc;
            }
        }
        
        args[@"sdk_v"] = @"1.0";
        
        NSDictionary *argsDict = [args copy];
        [argsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:NSString.class]) {
                NSString *value = (NSString *)obj;
                if (value.length == 0) {
                    [args removeObjectForKey:key];
                }
            }
        }];
        
        VDUploadCommitEvent_PageName_Arg1_Arg2_Arg3_Args(kVDUploadEventId,
                                                         kVDUploadPageName,
                                                         uploadSuccess,
                                                         @"CHUNK",
                                                         statusCode,
                                                         args);
    });
}

void VDUploadCommitEvent_PageName_Arg1_Arg2_Arg3_Args(NSString *eventId, NSString *pageName, NSString *arg1, NSString *arg2, NSString *arg3, NSDictionary *args) {
    Class utClass = NSClassFromString(@"WDUT");
    if (!utClass) {
        utClass = NSClassFromString(@"WDWT");
    }
    SEL utSelector = @selector(commitEvent:pageName:arg1:arg2:arg3:args:);
    if (utClass && [utClass respondsToSelector:utSelector]) {
        ((void(*)(id, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, NSDictionary *)) objc_msgSend)(utClass, utSelector, eventId, pageName, arg1, arg2, arg3, args);
    }
}

- (void)commitEvent:(NSString *)eventId
           pageName:(NSString *)pageName
               arg1:(NSString *)arg1
               arg2:(NSString *)arg2
               arg3:(NSString *)arg3
               args:(NSDictionary *)args
{
    // placeholder
}

@end
