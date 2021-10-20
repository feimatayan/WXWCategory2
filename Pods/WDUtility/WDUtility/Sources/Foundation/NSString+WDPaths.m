//
//  Created by Henson on 9/28/15.
//  Copyright (c) 2015 Henson. All rights reserved.
//

#import "NSString+WDPaths.h"

@implementation NSString (WDPaths)

+ (NSString *)wd_cachesPath {
    static dispatch_once_t onceToken;
    static NSString *cachePath;
    
    dispatch_once(&onceToken, ^{
        cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachePath;
}

+ (NSString *)wd_documentPath {
    static dispatch_once_t onceToken;
    static NSString *documentPath;
    
    dispatch_once(&onceToken, ^{
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return documentPath;
}

+ (NSString *)wd_temporaryPath {
    static dispatch_once_t onceToken;
    static NSString *temporaryPath;
    
    dispatch_once(&onceToken, ^{
        temporaryPath = NSTemporaryDirectory();
    });
    
    return temporaryPath;
}

+ (NSString *)wd_resourcePath {
    static dispatch_once_t onceToken;
    static NSString *resourcePath;
    
    dispatch_once(&onceToken, ^{
        resourcePath = [[NSBundle mainBundle] resourcePath];
    });
    
    return resourcePath;
}

@end
