//
//  GLIMSwipeableTableCell.h
//  GLIMSDK
//
//  Created by Acorld on 15-6-24.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM (NSInteger, GLIMSwipeableCellState) {
    GLIMSwipeableCellStateCenter,   // 正常居中显示
    GLIMSwipeableCellStateRight     // 左滑状态
};

@class GLIMSwipeableTableCell;

@protocol GLIMSwipeableCellDelegate <NSObject>

@optional
/// cell 点击右边按钮
- (void)swipeableCell:(GLIMSwipeableTableCell*)cell buttonClicked:(NSInteger)buttonIndex button:(UIButton *)btn;

/// cell 修改滑动状态
- (BOOL)swipealbeCell:(GLIMSwipeableTableCell *)cell canChangeCellState:(GLIMSwipeableCellState)cellState;
- (void)swipeableCell:(GLIMSwipeableTableCell *)cell willChangeCellState:(GLIMSwipeableCellState)cellState;
- (void)swipeableCell:(GLIMSwipeableTableCell *)cell didChangeCellState:(GLIMSwipeableCellState)cellState;

@end


#pragma mark - 滑动Cell
@interface GLIMSwipeableTableCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *mySuperView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *ownerTableView;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, weak) id<GLIMSwipeableCellDelegate> swipeDelegate;

@property (nonatomic, assign) BOOL isSwipeable; // 是否可滑动

- (instancetype)initWithFrame:(CGRect)frame
            rightButtonsArray:(NSArray *)buttonsArray
              reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetButtonsArray:(NSArray *)buttonsArray;

/// 恢复Cell为正常状态
- (void)resetSwipeStateAnimated:(BOOL)animated;

@end
