//
//  GLIMFoundationConfig.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/25.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GLIMEnvironmentType)
{
    GLIMEnvironmentNone,        // 未设置
    GLIMEnvironmentOnline,      // 线上环境
    GLIMEnvironmentPreLine,     // 预上线环境
    GLIMEnvironmentTest,        // 测试环境
};


@interface GLIMFoundationConfig : NSObject

/// 当前环境类型
@property (nonatomic, assign) GLIMEnvironmentType environmentType;
/// 图片文件上传地址
@property (nonatomic, strong) NSString *imageUploadUrl;
/// 音频文件上传地址
@property (nonatomic, strong) NSString *audioUploadUrl;

+ (instancetype)sharedConfig;

@end
