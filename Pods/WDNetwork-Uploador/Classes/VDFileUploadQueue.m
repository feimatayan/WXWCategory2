//
//  VDFileUploadQueue.m
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2017/10/24.
//  Copyright © 2017年 yangxin02. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "VDFileUploadQueue.h"
#import "VDUploadMission.h"

#import <WDNetwork-Base/WDNetworkConstant.h>
#import <WDNetwork-Base/NSString+WDNetwork.h>


NSOperationQueue * wdn_upload_queue() {
    static NSOperationQueue *_httpQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpQueue = [[NSOperationQueue alloc] init];
        _httpQueue.maxConcurrentOperationCount = 3;
    });

    return _httpQueue;
}


static NSString         *kTmpDirectory = nil;
static NSMutableArray   *kWaittingQ = nil;
static NSMutableArray   *kWorkingQ = nil;


@implementation VDFileUploadQueue

+ (void)initialize {
    // 创建文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [NSString stringWithFormat:@"%@", paths[0]];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentPath, @"wdn_tmp_imgs"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    kTmpDirectory = path;
    kWaittingQ = [NSMutableArray array];
    kWorkingQ  = [NSMutableArray array];
}

+ (NSString *)createTmpFilePath:(NSString *)uploadId {
    if (uploadId.length == 0) {
        uploadId = @"tmp";
    }
    
    return [kTmpDirectory stringByAppendingPathComponent:uploadId];
}

+ (NSString *)saveTmpFileData:(NSData *)fileData uploadId:(NSString *)uploadId {
    if (fileData == nil || uploadId.length == 0) {
        return nil;
    }
    
    NSString *localPath = [self createTmpFilePath:uploadId];
    if ([fileData writeToFile:localPath atomically:YES]) {
        return localPath;
    }
    
    return nil;
}

+ (BOOL)removeTmpFile:(NSString *)filePath {
    // TODO 在启动或者其他时机，清理一下临时文件
    // TODO 图片看看，不要用临时文件了
    
    if ([NSString wdn_isNotEmpty:filePath]) {
        NSFileManager *fileMg = [NSFileManager defaultManager];
        if ([fileMg fileExistsAtPath:filePath]) {
            return [fileMg removeItemAtPath:filePath error:nil];
        }
    }
    
    return YES;
}

+ (void)addUploadMission:(VDUploadMission *)mission {
    @synchronized([VDFileUploadQueue class]) {
        NSInteger maxCount = wdn_upload_queue().maxConcurrentOperationCount;
        if (kWorkingQ.count >= maxCount) {
            [kWaittingQ addObject:mission];
            
            // 保存到文件
            [self saveFile:mission];
        } else {
            [kWorkingQ addObject:mission];
            
            // 上传
            [mission upload];
        }
    }
}

+ (void)addUploadMissionList:(NSArray<VDUploadMission *> *)missionList {
    for (VDUploadMission *mission in missionList) {
        [self addUploadMission:mission];
    }
}

+ (void)doNextAfterMission:(VDUploadMission *)mission {
    @synchronized([VDFileUploadQueue class]) {
        [kWorkingQ removeObject:mission];

        NSInteger maxCount = wdn_upload_queue().maxConcurrentOperationCount;
        if (kWorkingQ.count < maxCount && kWaittingQ.count > 0) {
            VDUploadMission *nextMission = kWaittingQ[0];
            
            [kWaittingQ removeObjectAtIndex:0];
            [kWorkingQ addObject:nextMission];
            
            [nextMission upload];
        }
    }
}

+ (void)doNextAfterMissionList:(NSArray<VDUploadMission *> *)missionList {
    @synchronized([VDFileUploadQueue class]) {
        for (VDUploadMission *mission in missionList) {
            if ([kWorkingQ containsObject:mission]) {
                [kWorkingQ removeObject:mission];
            } else if ([kWaittingQ containsObject:mission]) {
                [kWaittingQ removeObject:mission];
            }
        }
        
        NSInteger maxCount = wdn_upload_queue().maxConcurrentOperationCount;
        if (kWorkingQ.count < maxCount && kWaittingQ.count > 0) {
            VDUploadMission *nextMission = kWaittingQ[0];
            
            [kWaittingQ removeObjectAtIndex:0];
            [kWorkingQ addObject:nextMission];
            
            [nextMission upload];
        }
    }
}

+ (void)saveFile:(VDUploadMission *)mission {
    if (mission.fileData == nil) {
        return;
    }
    
    if (mission.fileData) {
        NSString *localPath = [self createTmpFilePath:mission.uploadId];
        if ([mission.fileData writeToFile:localPath atomically:YES]) {
            mission.filePath = localPath;
            
            mission.fileData = nil;
        } else {
            mission.filePath = nil;
        }
    }
}

+ (void)removeFileByMission:(VDUploadMission *)mission {
    if (mission.filePath.length == 0) {
        return;
    }
    
    if (mission.isOriginPath) {
        return;
    }
    
    NSFileManager *fileMg = [NSFileManager defaultManager];
    if ([fileMg fileExistsAtPath:mission.filePath]) {
        [fileMg removeItemAtPath:mission.filePath error:nil];
    }
}

@end
