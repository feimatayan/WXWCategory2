//
//  VDCompressUT.h
//  VDCompress
//
//  Created by weidian2015090112 on 2018/10/8.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VDCompressUTDO : NSObject

// 原图大小
@property (nonatomic, assign) NSInteger sourceFileSize;
// 压缩后图片大小
@property (nonatomic, assign) NSInteger compressFileSize;
// 原始图片尺寸
@property (nonatomic, assign) CGSize sourceImgSize;
// 压缩后的尺寸
@property (nonatomic, assign) CGSize compressImgSize;

// compressOptions
@property (nonatomic, assign) NSInteger maxFileSize;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;

// 0 表示PNG
@property (nonatomic, assign) CGFloat quality;

@end


@interface VDCompressUT : NSObject


/**
 图片压缩埋点

 @param success 是否压缩成功
 @param time 压缩耗时

 @param args 其他参数
 */
+ (void)vdUT_success:(BOOL)success
                time:(double)time
                args:(VDCompressUTDO *)args;

@end
