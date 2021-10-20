//
//  GLIMRecentExtensibleCell.h
//  GLIMUI
//
//  Created by huangbiao on 2018/7/24.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 最近联系人扩展功能Cell
 */
@interface GLIMRecentExtensibleCell : UITableViewCell

/**
 计算扩展功能Cell

 @param cellData cell数据
 @return cell高度
 */
+ (CGFloat)cellHeightWithCellData:(id)cellData;

@property (nonatomic, strong) id cellData;

@end
