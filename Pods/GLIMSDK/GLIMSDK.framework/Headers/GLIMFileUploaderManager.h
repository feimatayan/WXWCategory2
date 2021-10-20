//
//  GLIMFileUploaderManager.h
//  GLIMSDK
//
//  Created by huangbiao on 16/3/17.
//  Copyright © 2016年 koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLIMFoundationDefine.h"
//#import "GLIMFileUploadServiceCenter.h"


/* 由于引入视频返回值，因此返回结果调整成字典
 * 字典格式为
 * {"url":"xxxx", "videoId":"xxxxx",  "videoCover":"xxxxx"}
 */



typedef void(^GLIMUploadFileCompletion)(NSDictionary *resultDict, NSString *key, NSError *error);

typedef void(^GLIMUploadFileStartBlock)(NSString *key);



@class GLIMFileUploaderManager;
@interface GLIMFileUploadData : NSObject

@property (nonatomic, strong) GLIMFileUploaderManager *fileUploader;
@property (nonatomic, strong) NSString *fileKey;
@property (nonatomic, strong) id fileData;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL usingSplit;  // 使用分片上传，默认为NO：不使用
@property (nonatomic, copy) GLIMUploadFileCompletion completion;
@property (nonatomic, copy) GLIMUploadFileStartBlock startBlock;

//当前scope
@property (nonatomic, copy) NSString *scope;

@end



/**
 *  @author huangbiao, 16-03-17 21:03:43
 *
 *  文件上传管理
 */
@interface GLIMFileUploaderManager : NSObject

/**
 *  @author huangbiao, 16-03-17 20:03:25
 *
 *  上传文件（分片上传）
 *
 *  @param data    文件数据
 *  @param success 上传成功回调
 *  @param failure 上传失败回调
 */
- (void)uploadFile:(NSData *)data
           success:(void(^)(NSString *url))success
           failure:(void(^)(NSError *error))failure;

/**
 *  @author huangbiao, 16-12-26 20:03:25
 *
 *  上传文件
 *
 *  @param data         文件数据
 *  @param usingSplit   YES: 使用分片上传，NO: 完整上传
 *  @param success      上传成功回调
 *  @param failure      上传失败回调
 */
- (void)uploadFile:(NSData *)data
        usingSplit:(BOOL)usingSplit
           success:(void(^)(NSString *url))success
           failure:(void(^)(NSError *error))failure;

/// 上传文件，为组件上传文件预留的接口，内部为空实现
/// @param data 文件数据或文件地址
/// @param usingSplit YES：使用分片上传，NO：完整上传
/// @param completion 回调函数，失败返回错误信息，成功返回字典，字典格式为{"url":"xxxx", "videoId":"xxxxx",  "videoCover":"xxxxx"}
- (void)uploadFile:(id)data
        usingSplit:(BOOL)usingSplit
        completion:(GLIMCompletionBlock)completion;



- (void)uploadFile:(id)data
    fileUploadData:(GLIMFileUploadData *)fileUploadData
        completion:(GLIMCompletionBlock)completion;

/// 检查返回结果是否出错
/// @param resultDict 返回结果
- (NSError *)invalidErrorWithResult:(NSDictionary *)resultDict;

@end


/**
 *  @author huangbiao, 16-03-17 21:03:29
 *
 *  图片上传管理
 */
@interface GLIMImageUploaderManager : GLIMFileUploaderManager

+ (GLIMImageUploaderManager *)sharedInstance;

@end


/**
 *  @author huangbiao, 16-03-17 21:03:54
 *
 *  音频上传管理
 */
@interface GLIMAudioUploaderManager : GLIMFileUploaderManager

+ (GLIMAudioUploaderManager *)sharedInstance;

@end
