//
//  VDFileUploaderProcessDO.h
//  VDUploador
//
//  Created by 杨鑫 on 2021/5/20.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VDFileUploaderProcessDO : NSObject

+ (instancetype)createWithData:(NSData *)data size:(long long)size;

+ (instancetype)createWithPath:(NSString *)path isOrigin:(BOOL)isOrigin size:(long long)size;

@property (nonatomic, strong, readonly) NSData *fileData;

@property (nonatomic, copy  , readonly) NSString *filePath;
// 是否是业务传的路径，如果是不用删除，如果不是上传完成后就需要删除
@property (nonatomic, assign, readonly) BOOL isOriginPath;

@property (nonatomic, assign, readonly) long long fileSize;

@end
