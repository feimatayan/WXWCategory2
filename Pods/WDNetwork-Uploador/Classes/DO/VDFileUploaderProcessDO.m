//
//  VDFileUploaderProcessDO.m
//  VDUploador
//
//  Created by 杨鑫 on 2021/5/20.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import "VDFileUploaderProcessDO.h"


@interface VDFileUploaderProcessDO ()

@property (nonatomic, strong) NSData *fileData;

@property (nonatomic, copy  ) NSString *filePath;
// 是否是业务传的路径，如果是不用删除，如果不是上传完成后就需要删除
@property (nonatomic, assign) BOOL isOriginPath;

@property (nonatomic, assign) long long fileSize;

@end

@implementation VDFileUploaderProcessDO

+ (instancetype)createWithData:(NSData *)data size:(long long)size {
    VDFileUploaderProcessDO *processDO = [VDFileUploaderProcessDO new];
    
    processDO.fileData = data;
    processDO.fileSize = size;
    
    return processDO;
}

+ (instancetype)createWithPath:(NSString *)path isOrigin:(BOOL)isOrigin size:(long long)size {
    VDFileUploaderProcessDO *processDO = [VDFileUploaderProcessDO new];
    
    processDO.filePath = path;
    processDO.isOriginPath = isOrigin;
    processDO.fileSize = size;
    
    return processDO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOriginPath = NO;
    }
    return self;
}

@end
