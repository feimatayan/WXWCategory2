//
//  GLTableViewCell.h
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLTableViewCell : UITableViewCell


/// 隐藏底部分割线 default NO
@property (nonatomic, assign) BOOL      hideLineFlag;
/// 整行底部分割线 default NO
@property (nonatomic, assign) BOOL      fullLineFlag;
/// 底部分割线距左侧的距离 default 10
@property (nonatomic, assign) CGFloat   leftMarginLine;
/// 底部分割线右侧的距离 default 0
@property (nonatomic, assign) CGFloat   rightMarginLine;


/// TODO UI Init
- (void)glSetup;

/// TODO UI Frame
- (void)glCustomLayoutFrame:(CGRect)frame;



@end
