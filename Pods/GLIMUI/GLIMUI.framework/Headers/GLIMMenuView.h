//
//  GLIMMenuView.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
/**
 *  @author Acorld, 15-04-23
 *
 *  @brief  弹出菜单的类型
 */
typedef NS_OPTIONS(NSUInteger, GLIMMenuItemType){
    /**
     *  @author Acorld, 15-04-23
     *
     *  @brief  无操作
     */
    GLIMMenuItemTypeNone     = 0,
    /**
     *  @author Acorld, 15-04-23
     *
     *  @brief  复制
     */
    GLIMMenuItemTypeCopy     = 1 << 0,
    /**
     *  @author Acorld, 15-04-23
     *
     *  @brief  转发
     */
    GLIMMenuItemTypeForward  = 1 << 1,
    /**
     *  @author jiakun, 18-08-15
     *
     *  @brief  撤回
     */
    GLIMMenuItemTypeWithdraw  = 1 << 2,
    /**
     *  @author jiakun, 18-11-1
     *
     *  @brief  连续播放
     */
    GLIMMenuItemTypeSoundContinuityPlay  = 1 << 3,
    /**
     *  @author jiakun, 18-11-1
     *
     *  @brief  扬声器播放/听筒播放
     */
    GLIMMenuItemTypeSoundSpeakerAndReceiverPlay  = 1 << 4,
    /**
     *  @author jiakun, 2018年12月03日11:51:05
     *
     *  @brief  消息删除
     */
    GLIMMenuItemTypeMessageDelete = 1 << 5,
    
    
    //收藏表情
    GLIMMenuItemTypeMessageEmojCustomExpression = 1 << 6,
    
    
    //群精华
    GLIMMenuItemTypeMessageGroupEssence = 1 << 7,
    
    /**
     *  @author Acorld, 15-04-23
     *
     *  @brief  更多
     */
    GLIMMenuItemTypeMore     = 1 << 10
};

@class GLIMMenuView;
@protocol GLIMMenuViewDelegate <NSObject>

@optional
- (void)didTapGLMMenuItem:(GLIMMenuView *)menuView;

@end
@protocol GLIMMenuViewDataSource <NSObject>

@required
- (GLIMMenuItemType)menuItemsForGLMMenuItem:(GLIMMenuView *)menuItem;

@optional
- (NSString *)stringToCopyForGLMMenuItem:(GLIMMenuView *)menuItem;
- (CGRect)rectForShowGLMMenuItem:(GLIMMenuView *)menuItem;

@end

@interface GLIMMenuView : UIView
@property (nonatomic, weak) id <GLIMMenuViewDelegate> delegate;

@property (nonatomic, weak) id <GLIMMenuViewDataSource> dataSource;

@property (nonatomic,strong) GLIMMessage * message;

/// 当前操作的item类型，类型唯一
@property (nonatomic, assign) GLIMMenuItemType currentItemType;

- (id)initGLMMenuViewWithFrame:(CGRect)frame;

/**
 *  @author Acorld, 15-04-23
 *
 *  @brief  展示操作气泡
 */
- (void)showPopView;

@end
