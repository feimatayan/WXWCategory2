//
//  GLTableView.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLTableView.h"

@implementation GLTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedRowHeight = 0;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}


@end
