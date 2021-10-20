//
//  GLIMRecentADCell.h
//  GLIMUI
//
//  Created by 六度 on 2017/12/12.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLIMRecentADCell : UITableViewCell
//ad业务数据 传入着自己关心
@property (nonatomic,strong) id adData;
//cell本身高度 最高150
+ (CGFloat)cellHeightWithAdData:(id)adData;

@end
