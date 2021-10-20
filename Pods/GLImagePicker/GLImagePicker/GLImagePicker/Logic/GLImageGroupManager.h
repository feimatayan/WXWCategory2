//
//  GLImageGroupManager.h
//  GLImagePicker
//
//  Created by zhangylong on 2021/2/3.
//

#import <Foundation/Foundation.h>


#import "GLFetchImageGroup.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, GLFetchGoupStatus) {
    GLFetchGoupStatusInit = 0,   // 初始化
    GLFetchGoupStatusComplete   // 最近联系
} ;

@interface GLImageGroupManager : NSObject


/// 相册列表
@property (atomic, strong) NSMutableArray *collectionGroupArray;


/// 相册列表刷新完成
@property (nonatomic, assign) BOOL freshComplete;


/// 相册列表刷新完成
@property (nonatomic, assign) GLFetchGoupStatus freshStatus;


/**
 *  选图 实例
 *
 *  @return 实例
 */
+ (GLImageGroupManager *)sharedInstance;


/// 更新相册列表数据
/// @param collectionArray 相册列表
- (void)updateCollectionArray:(NSArray *)collectionArray;



/// 往相册列表添加相册
/// @param group 单个相册列表数据
- (void)updateCollectionArrayWithSingeCollection:(GLFetchImageGroup *)group;



@end

NS_ASSUME_NONNULL_END
