//
//  VDUploadResultDO.h
//  WDNetworkingDemo
//
//  Created by wtwo on 16/8/25.
//  Copyright © 2016年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VDUploadVideosDO : NSObject

// 原视频（上传成功后必有）
@property (nonatomic, copy) NSString *f0;
// 流畅视频270P（未配置）
@property (nonatomic, copy) NSString *f10;
// 标清视频480P（原视频码率大于标清码率才有）
@property (nonatomic, copy) NSString *f20;
// 高清视频720P（未配置）
@property (nonatomic, copy) NSString *f30;
// 超清视频1080P（未配置）
@property (nonatomic, copy) NSString *f40;

@end

/**
 总对象
 */
@interface VDUploadResultDO : NSObject

@property (nonatomic, copy) NSString *traceId;

// sdk内部使用, 不要修改
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;

// 文件状态码
@property (nonatomic, assign) NSInteger state;
// 文件名
@property (nonatomic, copy) NSString *key;
// 公有访问 url
@property (nonatomic, copy) NSString *url;
// 图片内部访问url ，私有图片上传专有字段
@property (nonatomic, copy) NSString *innerUrl;
// 分片上传的唯一标识
@property (nonatomic, copy) NSString *uploadId;
// 分片序号
@property (nonatomic, assign) NSUInteger partId;

// 视频 ID，用于查询转码结果
@property (nonatomic, copy) NSString *videoId;
// 视频封面
@property (nonatomic, copy) NSString *thumbnail;
// gif
@property (nonatomic, copy) NSString *gifUrl;
// 各个分辨的链接
@property (nonatomic, strong) VDUploadVideosDO *videos;

@property (nonatomic, copy) NSDictionary *originResult;

@end
