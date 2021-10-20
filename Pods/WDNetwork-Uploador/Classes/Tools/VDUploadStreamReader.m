//
//  VDUploadStreamReader.m
//  VDUploador
//
//  Created by 杨鑫 on 2021/5/21.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import "VDUploadStreamReader.h"

#import <WDNetwork-Base/WDNErrorDO.h>


@interface VDUploadStreamReader ()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, assign) NSUInteger partIndex;

@property (nonatomic, assign) NSUInteger partCount;
@property (nonatomic, assign) NSUInteger partSize;

@property (nonatomic, assign) unsigned long long offset;

@property (nonatomic, assign) unsigned long long fileSize;

@end

@implementation VDUploadStreamReader

- (instancetype)initWithPath:(NSString *)path partSize:(NSUInteger)partSize {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (fileHandle == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.filePath = path;
        self.fileHandle = fileHandle;
        self.partSize = partSize;
        self.fileSize = 0;
        self.offset = 0;
    }
    return self;
}

- (WDNErrorDO *)updateFileSize {
    if (self.partSize == 0) {
        return [WDNErrorDO errorWithCode:WDNClientParamError msg:@"分片定义不能为空"];
    }
    
    unsigned long long fileSize = 0;
    if (@available(iOS 13.0, *)) {
        NSError *error;
        
        [self.fileHandle seekToEndReturningOffset:&fileSize error:&error];
        if (error) {
            return [WDNErrorDO errorWithCode:WDNClientParamError msg:@"读取文件大小错误"];
        }
        self.offset = fileSize;
        
        [self.fileHandle seekToOffset:0 error:&error];
        if (error) {
            return [WDNErrorDO errorWithCode:WDNClientParamError msg:@"读取文件头错误"];
        }
        self.offset = 0;
        self.partIndex = 0;
    } else {
        fileSize = [self.fileHandle seekToEndOfFile];
        self.offset = fileSize;
        
        [self.fileHandle seekToFileOffset:0];
        self.offset = 0;
        self.partIndex = 0;
    }
    
    self.fileSize = fileSize;
    if (self.fileSize == 0) {
        return [WDNErrorDO errorWithCode:WDNClientParamError msg:@"读取的文件为空"];
    }
    
    // 改变一下分片大小, 平均分片
    double fPartSize = (double)self.partSize;
    double fLength = (double)fileSize;
    
    NSUInteger count = ceil( fLength / fPartSize );
    fPartSize = ceil( fLength / count );
    
    self.partSize = fPartSize;
    self.partCount = count;
    
    return nil;
}

- (NSData *)readNextIfEnd:(BOOL *)isEnd error:(WDNErrorDO **)error {
    if (self.offset < self.fileSize) {
        unsigned long long readSize = self.partSize;
        if (self.offset + readSize > self.fileSize) {
            *isEnd = YES;
            
            readSize = self.fileSize - self.offset;
        }
        
        NSData *partData;
        if (@available(iOS 13.0, *)) {
            NSError *readError;
            partData = [self.fileHandle readDataUpToLength:readSize error:&readError];
            if (readError) {
                *error = [WDNErrorDO httpCommonErrorWithError:readError];
                return nil;
            }
            
            NSError *seekError;
            [self.fileHandle seekToOffset:self.offset + readSize error:&seekError];
            if (seekError) {
                *error = [WDNErrorDO httpCommonErrorWithError:readError];
                return nil;
            }
        } else {
            partData = [self.fileHandle readDataOfLength:readSize];
            
            [self.fileHandle seekToFileOffset:self.offset + readSize];
        }
        
        self.partIndex += 1;
        self.offset += readSize;
        
        return partData;
    } else {
        *isEnd = YES;
        return nil;
    }
}

- (WDNErrorDO *)closeFile {
    if (@available(iOS 13.0, *)) {
        NSError *error;
        
        [self.fileHandle closeAndReturnError:&error];
        if (error) {
            return [WDNErrorDO errorWithCode:WDNClientParamError msg:@"文件关闭错误"];
        }
        
        self.fileHandle = nil;
    } else {
        [self.fileHandle closeFile];
        
        self.fileHandle = nil;
    }
    
    return nil;
}

- (WDNErrorDO *)reSeek {
    if (@available(iOS 13.0, *)) {
        NSError *error;
        
        [self.fileHandle seekToOffset:0 error:&error];
        if (error) {
            return [WDNErrorDO httpCommonErrorWithError:error];
        }
    } else {
        [self.fileHandle seekToFileOffset:0];
    }
    
    return nil;
}

@end
