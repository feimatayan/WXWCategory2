//
//  SyTableView.m
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-5.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//

#define kType_Header            1
#define kType_Footer            2
#define kBorder_GoBackButton     66


#import "GLRefreshTableView.h"
#import "GLRefreshTableHeaderView.h"
#import "GLRefreshTableFooterView.h"
#import "GLButton.h"
#import "GLTableView.h"
#import "GLRefreshTableViewConstant.h"
#import "GLUIKitUtils.h"


@interface GLRefreshTableView ()
{
    /// 头部刷新
    GLRefreshTableHeaderView    *_tableHeaderView;
    /// 底部刷新
    GLRefreshTableFooterView    *_tableFooterView;
    /// 上一次的位移
    CGFloat                     _lastOffsetY;
    BOOL                        _isDragEnd;
}


@end


@implementation GLRefreshTableView

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    /*
     *
     * delegate must be weak ,otherwise _tableView wouldn't dealloc and it will crash.
     *
     */

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setupWithTableViewStype:UITableViewStylePlain];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithTableViewStype:style];
    }
    return self;
}


- (void)setupWithTableViewStype:(UITableViewStyle)style
{
    if (!_tableView) {
        
        _tableView                  = [[GLTableView alloc] initWithFrame:CGRectZero style:style];
        // 把当前类设为 代理 实现scroll代理方法
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_tableView];
    }
    
    
    
//    if (!_goBackButton) {
//        // 返回顶部 Button
//        _goBackButton               = [GLButton buttonWithType:UIButtonTypeCustom];
//        _goBackButton.alpha         = 0;
//        
//        
//        [_goBackButton setBackgroundImage:[UIImage imageNamed:@"btn_arrow_normal"]
//                                 forState:UIControlStateNormal];
//        
//        [_goBackButton setBackgroundImage:[UIImage imageNamed:@"btn_arrow_pressed"]
//                                 forState:UIControlStateHighlighted];
//        
//        [_goBackButton addTarget:self
//                          action:@selector(goBackButtonAction:)
//                forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:_goBackButton];
//    }
    
}

/**
 *  @brief  添加下拉刷新
 */
- (void)setupTableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[GLRefreshTableHeaderView alloc] init];
        [_tableHeaderView updateStyle:GLRefreshTableHeaderViewStylePull];
        [_tableView addSubview:_tableHeaderView];
    }
}

/**
 * @brief   添加加载更多
 *
 * 1.一开始底部加载隐藏，滑动触发加载更多
 *
 */
- (void)setupTableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[GLRefreshTableFooterView alloc] init];
        [_tableFooterView updateStyle:GLRefreshTableFooterViewPull];
        [_tableView addSubview:_tableFooterView];
    }
}

/**
 *  @brief  同时设置下拉刷新和加载更多
 */
- (void)setupTableHeaderAndTableFooterView
{
    [self setupTableHeaderView];
    [self setupTableFooterView];
}


/**
 *  展开下拉加载
 */
- (void)showHeadLoading
{
    // must reload
    [_tableView reloadData];
    if (_tableHeaderView && _tableHeaderView.currentStyle != GLRefreshTableHeaderViewStyleLoading) {
        [_tableHeaderView startLoading:_tableView animated:YES];
    }

}

/**
 *  收起下拉加载
 */
- (void)hideHeadLoading
{
    // must reload
    [_tableView reloadData];
    if (_tableHeaderView && _tableHeaderView.currentStyle != GLRefreshTableHeaderViewStylePull) {
        [_tableHeaderView finishLoading:_tableView animated:YES];
    }
}


- (void)reloadData
{
    if (_tableView) {
        [_tableView reloadData];
        [self setNeedsLayout];
    }
}

- (void)reloadDataAndReset
{
    [self resetTableHeaderAndTableFooterView];
    [self reloadData];
}

- (void)resetTableHeaderAndTableFooterView
{
    [self resetTableHeaderView];
    [self resetTableFooterView];
}

- (void)resetTableHeaderView
{
    if (_tableHeaderView && _tableHeaderView.currentStyle != GLRefreshTableHeaderViewStylePull) {
        [self hideHeadLoading];
    }
    _isRefresh = NO;
}

- (void)resetTableFooterView
{
    if (_tableFooterView && _tableFooterView.currentStyle != GLRefreshTableFooterViewPull) {
        [_tableFooterView updateStyle:GLRefreshTableFooterViewPull];
    }
    _isRefresh = NO;
}

- (void)updateFootViewNoData
{
    if (_tableFooterView) {
        [_tableFooterView updateStyle:GLRefreshTableFooterViewNoData];
    }
}

#pragma mark -  action
//- (void)goBackButtonAction:(id)sender
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(tableviewScrollToTopAction)]) {
//        [_delegate tableviewScrollToTopAction];
//    }
//    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//}


/**
 *  返回按钮 显示 处理
 */
//- (void)handleGoBackButton
//{
//    CGFloat offsetY = _tableView.contentOffset.y;
//    
//    if (offsetY > _tableView.height) {
//        if (_goBackButton.alpha == 0) {
//            [UIView animateWithDuration:0.5 animations:^{
//                _goBackButton.alpha = 1;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//    } else {
//        if (_goBackButton.alpha == 1) {
//            // 只掉一次
//            [UIView animateWithDuration:0.5 animations:^{
//                _goBackButton.alpha = 0;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//    }
//}

/**
 *  scroll action
 */
- (void)handleDrag
{
    if (_isRefresh || _isDragEnd) {
        return;
    } 
    
    CGFloat offsetY = _tableView.contentOffset.y;
    if (offsetY > _lastOffsetY) {
        CGPoint offset = _tableView.contentOffset;
        CGSize cSize = _tableView.contentSize;
        CGFloat draggedDistance = (_tableView.frame.size.height - cSize.height) + offset.y;
        if (draggedDistance > 0) {
            // MARK:加载更多 不足一屏幕
            if (_tableFooterView && _tableFooterView.currentStyle == GLRefreshTableFooterViewPull) {
                [_tableFooterView updateStyle:GLRefreshTableFooterViewRelease];
            }
        } else {
            if (draggedDistance > - 80) {
                // MARK:加载更多 多于一屏幕
                if (_tableFooterView && _tableFooterView.currentStyle == GLRefreshTableFooterViewPull) {
                    [_tableFooterView updateStyle:GLRefreshTableFooterViewLoading];
                    if (_delegate && [_delegate respondsToSelector:@selector(tableviewFooterRefresh:)]) {
                        _isRefresh = YES;
                        [_delegate tableviewFooterRefresh:self];
                        
                    }
                }
            }
        }
        
    } else if (offsetY < _lastOffsetY) {
        if (offsetY <= -kHeight_PullDown) {
            // MARK:下拉刷新
            if (_tableHeaderView && _tableHeaderView.currentStyle == GLRefreshTableHeaderViewStylePull) {
                [_tableHeaderView updateStyle:GLRefreshTableHeaderViewStyleRelease];
            }
        }
    }
}

/**
 *  拖动 释放 aciton
 */
- (void)handleDragEnd
{
    if (_isRefresh) {
        return;
    }
    
    if ((_tableHeaderView && _tableHeaderView.currentStyle == GLRefreshTableHeaderViewStyleLoading) ||
        (_tableFooterView && _tableFooterView.currentStyle == GLRefreshTableFooterViewLoading)) {
        return;
    }
    
    if (_tableHeaderView && _tableHeaderView.currentStyle == GLRefreshTableHeaderViewStyleRelease) {
        [self headerViewBeginRefresh];
    }
    
    
    if (_tableFooterView && _tableFooterView.currentStyle == GLRefreshTableFooterViewRelease) {
        [self footerViewBeginRefresh];
    }
}


/**
 *  头部开始刷新
 */
- (void)headerViewBeginRefresh
{
    [_tableHeaderView startLoading:_tableView animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tableViewHeaderReresh:)]) {
        if (!_isRefresh) {
            _isRefresh = YES;
            [_delegate tableViewHeaderReresh:self];
        }
    }
}

/**
 *  底部开始刷新
 */
- (void)footerViewBeginRefresh
{
    if (_delegate && [_delegate respondsToSelector:@selector(tableviewFooterRefresh:)]) {
        [_tableFooterView updateStyle:GLRefreshTableFooterViewLoading];
        if (!_isRefresh) {
            _isRefresh = YES;
            [_delegate tableviewFooterRefresh:self];
        }
    }
}

#pragma mark - 移除下拉刷新
- (void)disableTableHeaderView
{
    if (_tableHeaderView) {
        // 状态重置
        [self resetTableHeaderView];
        [_tableHeaderView removeFromSuperview];
        _tableHeaderView = nil;
    }
}

#pragma mark - 移除上拉翻页
- (void)disableTableFooterView
{
    if (_tableFooterView) {
        // 状态重置
        [self resetTableFooterView];
        [_tableFooterView removeFromSuperview];
        _tableFooterView = nil;
    }
}
- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    [self setNeedsLayout];
}


#pragma mark- layout
#pragma mark- layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame =  CGRectMake(0, 0, self.width, self.height);
    _tableHeaderView.frame = CGRectMake(0, -self.height, self.width, self.height);
    
    UIEdgeInsets mySafeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        mySafeAreaInsets = _tableView.safeAreaInsets;
    } else {
        
    }
    
    _tableFooterView.frame = CGRectMake(0, _tableView.contentSize.height + mySafeAreaInsets.bottom, self.width, kHeight_HeaderView);
    //    _goBackButton.frame = CGRectMake(self.width - kBorder_GoBackButton, self.height - kBorder_GoBackButton - 40, kBorder_GoBackButton, kBorder_GoBackButton);
}


//#########################################################
//------------------ UIScrollViewDelegate<NSObject>

#pragma mark- UIScrollViewDelegate
// scrollView.contentSize.height = scrollView.bounds.size.height + scrollView.contentOffset.y
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    // delegate
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
    // go back button
//    [self handleGoBackButton];
    
    // drag
    [self handleDrag];
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView) {
        // delegate
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
            [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        }
        // drag end
        _isDragEnd = YES;
        [self handleDragEnd];
        
    }
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
            [_delegate scrollViewDidZoom:scrollView];
        }
    }
    
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDragEnd = NO;
    _lastOffsetY = scrollView.contentOffset.y;
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
            [_delegate scrollViewWillBeginDragging:scrollView];
        }
    }
}
// called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
            [_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
        }

    }
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
            [_delegate scrollViewWillBeginDecelerating:scrollView];
        }
    }
}

 // called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
            [_delegate scrollViewDidEndDecelerating:scrollView];
        }
    }
}
// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
            [_delegate scrollViewDidEndScrollingAnimation:scrollView];
        }
    }
}
 // return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [_delegate viewForZoomingInScrollView:scrollView];
    }
    else
        return nil;
}
 // called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [_delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [_delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
//    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
//        return [_delegate scrollViewShouldScrollToTop:scrollView];
//    }
//    else
        return YES;
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [_delegate scrollViewDidScrollToTop:scrollView];
    }
}
//----------------------------------------------------------------------------------------------------------------
//                              UITableViewDataSource
#pragma mark- UITableViewDataSource 全部方法共 11
// 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [_dataSource tableView:tableView numberOfRowsInSection:section];
    }
    else {
        return 0;
    }
       
}

// 2
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell = [_dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            return cell;
        }
    }
    
    // zhengxf add 2016-01-17 fix dataSouce 为nil，tableview 做动画 crash
    static NSString *cellID = @"GLRefreshTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
// 3
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [_dataSource numberOfSectionsInTableView:tableView];
    }
    else {
        return 1;
    }
}
// 4
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [_dataSource tableView:tableView titleForHeaderInSection:section];
    }
    else {
        return @"";
    }
}
// 5
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [_dataSource tableView:tableView titleForFooterInSection:section];
    }
    else {
        return @"";
    }
}

// 6    Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [_dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }else {
        return NO;
    }
}

// 7    Moving/reordering
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [_dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }else {
        return NO;
    }
}

// 8    Index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [_dataSource sectionIndexTitlesForTableView:tableView];
    }else {
        return nil;
    }
}
// 9
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [_dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }else {
        return 0;
    }
}
// 10
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [_dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}
// 11
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (_dataSource && [_dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [_dataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

//--------------------------------------------------------------------------------------------------------------------
//                                  UITableViewDelegate 共22
#pragma mark- UITableViewDelegate 全部
//  1
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

// 2    Variable height support
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else
        return kHeight_CellDefault;
}
// 3
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_delegate tableView:tableView heightForHeaderInSection:section];
    }else
        return 0;
}
// 4
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_delegate tableView:tableView heightForFooterInSection:section];
    }else
        return 0;
}

// 5
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_delegate tableView:tableView viewForHeaderInSection:section];
    }else
        return nil;
}
// 6
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_delegate tableView:tableView viewForFooterInSection:section];
    }else
        return nil;
}

// 7    Accessories (disclosures). DEPRECATED
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{}
//  8
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        return [_delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}
#pragma mark Select
//  9    Selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [_delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }else
        return indexPath;
}
//  10
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [_delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }else
        return indexPath;
}
//  11
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
// 12
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}
//  13      Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }else
        return UITableViewCellEditingStyleNone;
}
// 14
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }else
        return @"";
}

// 15
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [_delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }else
        return NO;
}
// 16
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        return [_delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}
// 17
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        return [_delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// 18       Moving/reordering
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [_delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }else
        return nil;
}

// 19
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }else
        return 0;
}
// 20
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }else
        return NO;
}
// 21
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [_delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }else
        return NO;
}
// 22
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        return [_delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}


#pragma mark-
// 23
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [_delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

@end
