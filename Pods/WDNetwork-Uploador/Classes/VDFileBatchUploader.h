//
//  VDFileBatchUploader.h
//  WDNetworkingDemo
//
//  Created by weidian2015090112 on 2018/9/7.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import "VDFileUploader.h"


@interface VDFileBatchUploader : VDFileUploader


/**
 批量上传

 @param files 文件数组
 @param scope ""
 @param type 文件类型
 @param quality 图片压缩质量
 @param prv 是否私有, YES表示是私有图片
 @param unadjust 是否服务器端调整, YES表示不需要调整
 @param callback 回调

 @return hhh
 */
+ (instancetype)UploadFiles:(NSArray *)files
                      scope:(NSString *)scope
                       type:(VDUploadType)type
                    quality:(CGFloat)quality
                        prv:(BOOL)prv
                   unadjust:(BOOL)unadjust
                   callback:(void(^)(NSArray *results, WDNErrorDO *error))callback;

@end
