//
//  WDTNFileDownloader.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/11/3.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNFileDownloader.h"
#import "WDTNControlTask.h"
#import "WDTNRequestProcessor.h"
#import "WDTNAFResponseSerialization.h"
#import "WDTNDownloadTask.h"
#import "WDTNPrivateDefines.h"

#import <AFNetworking/AFNetworking.h>


typedef void (^NonPersistentSuccess)(NSData *data, NSURLRequest *request);
typedef void (^PersistentSuccess)(NSData *data, NSString *tmpPath, NSURLRequest *request);

@interface WDTNFileDownloader () <WDTNControlDelegate>
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer;

@property (nonatomic, strong) NSString *dirPath;
/// 每个request从创建到发送的执行队列
@property (nonatomic, strong) dispatch_queue_t requestQueue;
/// 保存 downloadTask,用于 cancel。
@property (nonatomic, strong) NSMutableDictionary *taskDict;
@end

@implementation WDTNFileDownloader

+ (instancetype)defaultLoader {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _requestQueue = dispatch_queue_create("com.weidian.WDTNFileDownloader.requestQueue", DISPATCH_QUEUE_SERIAL);
    
    _taskDict = [[NSMutableDictionary alloc] init];
    
    [self initSessionManager];
    [self initDirectory];
    
    return self;
}

- (void)initSessionManager {
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfiguration];
    _sessionManager.responseSerializer = (id<AFURLResponseSerialization>)[[WDTNAFResponseSerialization alloc] init];
    
    _requestSerializer = [AFHTTPRequestSerializer serializer];
}

// 初始化下载文件目录
- (void)initDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *cachePath = [paths objectAtIndex:0];
    self.dirPath = [cachePath stringByAppendingPathComponent:DownloadDirName];
    NSFileManager *fileMr = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![fileMr fileExistsAtPath:_dirPath isDirectory:&isDir]) {
        if (!isDir) {
            [fileMr createDirectoryAtPath:_dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}

- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSData *data, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure
{
    return [self GET:url
          parameters:parameters
           isBigFile:NO
            filePath:nil
          delTmpFile:NO
             success:success
             failure:failure
        isPersistent:NO];
}

- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
               isBigFile:(BOOL)isBigFile
                filePath:(NSString *)filePath
                 success:(void (^)(NSData *data, NSString *tmpPath, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure
{
    return [self GET:url
          parameters:parameters
           isBigFile:isBigFile
            filePath:filePath
          delTmpFile:NO
             success:success
             failure:failure];
}

- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
               isBigFile:(BOOL)isBigFile
                filePath:(NSString *)filePath
              delTmpFile:(BOOL)delTmpFile
                 success:(void (^)(NSData *data, NSString *tmpPath, NSURLRequest *request))success
                 failure:(void (^)(NSError *error, NSURLRequest *request))failure
{
    return [self GET:url
          parameters:parameters
           isBigFile:isBigFile
            filePath:filePath
          delTmpFile:delTmpFile
             success:success
             failure:failure
        isPersistent:YES];
}

- (WDTNControlTask *)GET:(NSString *)url
              parameters:(NSDictionary *)parameters
               isBigFile:(BOOL)isBigFile
                filePath:(NSString *)filePath
              delTmpFile:(BOOL)delTmpFile
                 success:(id)success
                 failure:(id)failure
            isPersistent:(BOOL)isPersistent
{
    NSAssert(url != nil, @"url不能为空");
 
    NSString *taskIdentifier = [WDTNRequestProcessor requestIdForURL:url params:parameters];
    
    dispatch_async(_requestQueue, ^{
        NSMutableURLRequest *request = [_requestSerializer requestWithMethod:@"GET"
                                                                   URLString:url
                                                                  parameters:parameters
                                                                       error:nil];
        NSURLSessionTask *sessionTask = nil;
        if (isBigFile == NO) {
            // 返回 responseData, 如果有 filepath，保存到磁盘
            neweakify(self);
            sessionTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                [NEWeak_self taskFinished:taskIdentifier
                                 response:response
                             responseData:responseObject
                               targetPath:nil
                                    error:error
                             isPersistent:isPersistent];
            }];
        } else {
            // 大文件不返还 responseData，只返回文件路径
            neweakify(self);
            sessionTask = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                // 文件保存路径
                if (filePath != nil) {
                    return [NSURL fileURLWithPath:filePath];
                } else {
                    NSString *copyPath = [NEWeak_self destinationFilePath:response.suggestedFilename];
                    return [NSURL fileURLWithPath:copyPath];
                }
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                [NEWeak_self taskFinished:taskIdentifier
                                 response:response
                             responseData:nil
                               targetPath:filePath.relativePath
                                    error:error
                             isPersistent:isPersistent];
            }];
        }
        
        WDTNResponseHandler *handler = [[WDTNResponseHandler alloc] initWithHandlerID:nil success:(id)success failure:(id)failure];
        
        WDTNDownloadTask *task = [[WDTNDownloadTask alloc] init];
        task.sessionTask = sessionTask;
        task.isBigFile = isBigFile;
        task.filePath = filePath;
        task.delTmpFile = delTmpFile;
        task.handler = handler;
        task.url = url;
        
        self.taskDict[taskIdentifier] = task;
        
        [sessionTask resume];
    });
    
    WDTNControlTask *controlTask = [[WDTNControlTask alloc] initWithControlID:nil taskIdentifier:taskIdentifier delegate:self];
    
    return controlTask;
}
 
#pragma mark - WDTNControlDelegate

- (void)canelTask:(WDTNControlTask *)controlTask {
    dispatch_sync(_requestQueue, ^{
        WDTNDownloadTask *task = _taskDict[controlTask.taskIdentifier];
        if (task != nil) {
            [task.sessionTask cancel];
            // 从字典中移除
            [_taskDict removeObjectForKey:controlTask.taskIdentifier];
        }
    });
}

#pragma mark - help

- (void)taskFinished:(NSString *)taskIdentifier
            response:(NSURLResponse *)response
        responseData:(NSData *)responseData
          targetPath:(NSString *)targetPath
               error:(NSError *)error
        isPersistent:(BOOL)isPersistent
{
    WDTNDownloadTask *task = _taskDict[taskIdentifier];
    BOOL isBigFile = task.isBigFile;
    NSString *filePath = task.filePath;
    WDTNReqResFailureBlock failure = task.handler.failureBlock;
    id successBlock = (id)task.handler.successBlock;
    
    NSInteger httpStatusCode = [(NSHTTPURLResponse *)response statusCode];
    
    if (httpStatusCode == 200) {
        if (successBlock != nil) {
            if (isPersistent == NO) {
                NonPersistentSuccess success = successBlock;
                success(responseData, task.sessionTask.originalRequest);
            } else {
                PersistentSuccess success = successBlock;
                if (isBigFile == NO) {
                    if (filePath != nil) {
                        [responseData writeToFile:filePath options:NSDataWritingAtomic error:nil];
                    }
                    success(responseData, filePath, task.sessionTask.originalRequest);
                    WDTNLog(@"download success,url =  %@, filepath: %@", task.url, filePath);
                } else {
                    success(nil, targetPath, task.sessionTask.originalRequest);
                    WDTNLog(@"download success,url =  %@, filepath: %@", task.url, targetPath);
                    
                    // 原来的删除有点问题，success回调完立马删除。。。也许业务方是异步的。。。
                    // 其实SDK不应该有这个删除逻辑，返回path了，业务方自己使用完删除。
                    if (task.delTmpFile) {
                        if (filePath != nil) {
                            [self deleteFileAtPath:filePath];
                        }
                    }
                }
            }
        }
    } else {
        if (failure != nil) {
            failure(error, response, task.sessionTask.originalRequest);
        }
        WDTNLog(@"download failure,url =  %@, error: %@", task.url, error);
    }
    
    // 调用完成，删除对象
    [self removeTask:taskIdentifier];
}

- (void)removeTask:(NSString *)taskIdentifier {
    dispatch_async(_requestQueue, ^{
        [_taskDict removeObjectForKey:taskIdentifier];
    });
}

- (NSString *)destinationFilePath:(NSString *)fileName {
    NSString *path = [_dirPath stringByAppendingPathComponent:fileName];
    return path;
}

- (void)deleteFileAtPath:(NSString *)path {
    NSFileManager *fileMr = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileMr fileExistsAtPath:path]) {
        [fileMr removeItemAtPath:path error:&error];
        WDTNLog(@"remove file at path : %@, error: %@", path, error);
    }
}

#pragma mark - setter

- (void)setCompletionGroup:(dispatch_group_t)completionGroup {
    _sessionManager.completionGroup = completionGroup;
}

- (void)setCompletionQueue:(dispatch_queue_t)completionQueue {
    _sessionManager.completionQueue = completionQueue;
}

@end
