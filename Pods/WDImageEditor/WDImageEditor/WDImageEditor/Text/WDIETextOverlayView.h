//
//  WDIETextOverlayView.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDIETextOverlayView : UIView

@property (nonatomic, strong, readonly) UIView *leftTopView;

@property (nonatomic, strong, readonly) UIView *leftBottomView;

@property (nonatomic, strong, readonly) UIView *rightTopView;

@property (nonatomic, strong, readonly) UIView *rightBottomView;

@end
