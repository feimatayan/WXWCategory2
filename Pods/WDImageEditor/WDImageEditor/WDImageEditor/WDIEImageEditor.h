//
//  WDIEImageEditor.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/10.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDIEImageEditor;

@protocol WDIEImageEditorDelegate <NSObject>

@optional

/**
 图片编辑器点击取消按钮

 @param imageEditor 图片编辑器
 */
- (void)imageEditorDidCancel:(WDIEImageEditor *)imageEditor;

/**
 图片编辑器点击完成按钮

 @param imageEditor 图片编辑器
 @param image 编辑后的图片
 */
- (void)imageEditor:(WDIEImageEditor *)imageEditor finishWithImage:(UIImage *)image;

@end


@interface WDIEImageEditor : UIViewController

@property (nonatomic, weak) id<WDIEImageEditorDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithImage:(UIImage *)image delegate:(id<WDIEImageEditorDelegate>)delegate;

@end
