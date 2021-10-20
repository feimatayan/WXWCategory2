//
//  WDTNDownloadTask.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/8.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDTNResponseHandler.h"

@interface WDTNDownloadTask : NSObject

@property (nonatomic, strong) NSString *taskIdentifier;
/// 实际发起请求的对象
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
/// 保存block块
@property (nonatomic, strong) WDTNResponseHandler* handler;
/// 下载文件保存路径
@property (nonatomic, strong) NSString *filePath;
/// 是否删除临时文件
@property (nonatomic, assign) BOOL delTmpFile;
/// 是否为大文件
@property (nonatomic, assign) BOOL isBigFile;
/// 下载文件的 url
@property (nonatomic, copy) NSString *url;

@end
