//
//  VDFileUploadConstant.h
//  WDNetworkingDemo
//
//  Created by wtwo on 16/8/29.
//  Copyright © 2016年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, VDUploadType) {
    VDUpload_IMG = 0,
//    VDUpload_GIF,
    VDUpload_AUDIO,
    VDUpload_VIDEO,
    VDUpload_DOC,
};


#define kKSize                  1024

#define kDefaultQuality         0.85f

#define kImageMaxSize           (6 * kKSize * kKSize)
#define kOriginImageMaxSize     (24 * kKSize * kKSize)

#define kUploadFileMaxSize      (20 * kKSize * kKSize)

/// 文档已经可以上传4G的视频了，直接上传
#define kVideoMaxSize           (512 * kKSize * kKSize)
#define kLongVideoMaxSize       (1024 * kKSize * kKSize)

#define kImg2GPartSize          (128 * kKSize)
#define kImg3GPartSize          (256 * kKSize)
#define kImg4GPartSize          (512 * kKSize)
#define kImgWIFIPartSize        (1024 * kKSize)

#define kVideo3GPartSize        (2 * kKSize * kKSize)
#define kVideo4GPartSize        (4 * kKSize * kKSize)
#define kVideoWIFIPartSize      (6 * kKSize * kKSize)


#define API_UPLOAD_DIRECT       @"upload/v3/direct"

#define API_PART_UPLOAD_INIT    @"upload/v3/initiatePart"
#define API_PART_UPLOAD         @"upload/v3/part"
#define API_PART_UPLOAD_OVER    @"upload/v3/finishPart"

#define API_UPLOAD_VIDEO_Q      @"query/video/v3/publicUrl?scope=<scope>&id=<id>"

