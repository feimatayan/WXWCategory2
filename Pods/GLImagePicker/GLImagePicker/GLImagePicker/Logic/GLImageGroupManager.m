//
//  GLImageGroupManager.m
//  GLImagePicker
//
//  Created by zhangylong on 2021/2/3.
//

#import "GLImageGroupManager.h"

@implementation GLImageGroupManager

+ (GLImageGroupManager *)sharedInstance
{
    static GLImageGroupManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _collectionGroupArray = [NSMutableArray new];
    }
    
    return self;
}


/// 更新相册列表数据
/// @param collectionArray 相册列表
- (void)updateCollectionArray:(NSArray *)collectionArray {
    
    if (collectionArray && collectionArray.count > 0) {
        
        for (GLFetchImageGroup *newGroup in collectionArray) {
            
            BOOL updatedOK = NO;
            // 看看是否已经在列表里了，在就更新，不在就添加
            for (GLFetchImageGroup *oldGroup in self.collectionGroupArray) {
                if ([oldGroup.name isEqualToString:newGroup.name]) {
                    [oldGroup updateWithFetchImageGroup:newGroup];
                    updatedOK = YES;
                    break;
                }
            }
            // 不在列表，添加
            if (!updatedOK) {
                if (newGroup.isFirst) {
                    [self.collectionGroupArray insertObject:newGroup atIndex:0];
                } else {
                    [self.collectionGroupArray addObject:newGroup];
                }
            }
        }
    }
    
}

/// 往相册列表添加相册
/// @param group 单个相册列表数据
- (void)updateCollectionArrayWithSingeCollection:(GLFetchImageGroup *)group {
    [self.collectionGroupArray addObject:group];
}




@end
