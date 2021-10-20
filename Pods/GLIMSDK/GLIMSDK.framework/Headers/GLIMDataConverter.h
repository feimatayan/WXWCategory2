//
//  GLIMDataConverter.h
//  GLIMSDK
//
//  Created by 六度 on 2017/2/17.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMDataConverter : NSObject

#pragma mark - JSON
+ (NSString *)jsonStringFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;

+ (NSArray *)arrayFromJsonString:(NSString *)jsonString;
+ (NSString *)jsonStringFromArray:(NSArray *)jsonArray;

#pragma mark - pb to dic
+ (NSDictionary *)propertiyDicForPB:(id)pb;


@end
