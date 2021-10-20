//
//  GLIMOffLineMessagePoolChoiceViewCell.h
//  GLIMUI
//
//  Created by jiakun on 2020/3/5.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GLIMOffLineMessagePoolChoiceViewCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *isShop;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *subUserId;
@property (nonatomic, strong) NSNumber *time;

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopUid;
@property (nonatomic, copy) NSString *from_source;

@end


@interface GLIMOffLineMessagePoolChoiceViewCell : UITableViewCell

@property (nonatomic, strong) GLIMOffLineMessagePoolChoiceViewCellModel *model;

+ (id)cellWith:(UITableView *)tableView;
+ (CGSize)cellSize:(GLIMOffLineMessagePoolChoiceViewCellModel *)data;

@end

NS_ASSUME_NONNULL_END
