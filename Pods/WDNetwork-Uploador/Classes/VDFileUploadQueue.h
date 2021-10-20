//
//  VDFileUploadQueue.h
//  WDNetworkingDemo
//
//  Created by yangxin02 on 2017/10/24.
//  Copyright © 2017年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern NSOperationQueue * wdn_upload_queue(void);

@class VDUploadMission;


///
@interface VDFileUploadQueue : NSObject

+ (NSString *)createTmpFilePath:(NSString *)uploadId;

// 临时存储文件
+ (NSString *)saveTmpFileData:(NSData *)fileData uploadId:(NSString *)uploadId;
+ (BOOL)removeTmpFile:(NSString *)filePath;

+ (void)addUploadMission:(VDUploadMission *)mission;

+ (void)addUploadMissionList:(NSArray<VDUploadMission *> *)missionList;

+ (void)doNextAfterMission:(VDUploadMission *)mission;

+ (void)doNextAfterMissionList:(NSArray<VDUploadMission *> *)missionList;

+ (void)saveFile:(VDUploadMission *)mission;

+ (void)removeFileByMission:(VDUploadMission *)mission;

@end
