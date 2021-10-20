//
//  GLFetchImageAsset.m
//  GLUIKit
//
//  Created by xiaofengzheng on 3/14/16.
//  Copyright © 2016 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLFetchImageAsset.h"

@implementation GLFetchImageAsset



/**
 *  用PHAsset实例化一个GLFetchImageAsset 对象
 *
 */
+ (GLFetchImageAsset *)getFetchImageAsseWithPHAsset:(PHAsset *)phAsset
{
    GLFetchImageAsset *fetchImageAsset = [[GLFetchImageAsset alloc] init];
    fetchImageAsset.isSelected = NO;
    fetchImageAsset.data = phAsset;
    
    
    return fetchImageAsset;
}




/**
 *  用ALAsset实例化一个GLFetchImageAsset 对象
 *
 */
+ (GLFetchImageAsset *)getFetchImageAsseWithALAsset:(ALAsset *)alAsset
{
    GLFetchImageAsset *fetchImageAsset = [[GLFetchImageAsset alloc] init];
    fetchImageAsset.isSelected = NO;
    fetchImageAsset.data = alAsset;
    
    return fetchImageAsset;
}


- (BOOL)isGIF
{
    if([self.data isKindOfClass:PHAsset.class]) {
        PHAsset *asset = self.data;
        if ([[asset valueForKey:self.fnkey] hasSuffix:@"GIF"]) {
            _isGIF = YES;
            return YES;
        }
    }
    _isGIF = NO;
    return NO;
}

- (NSString *)fnkey
{
    static NSString *string = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *data = [[NSData alloc]initWithBase64EncodedString:@"ZmlsZW5hbWU=" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    });
    return string;
}
@end
