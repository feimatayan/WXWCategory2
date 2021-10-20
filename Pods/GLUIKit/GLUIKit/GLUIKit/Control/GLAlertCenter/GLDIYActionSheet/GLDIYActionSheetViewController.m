//
//  GLDIYActionSheetViewController.m
//  GLUIKit
//
//  Created by smallsao on 2021/7/22.
//

#import "GLDIYActionSheetViewController.h"
#import "GLColorConstants.h"
#import "GLUIKitUtils.h"
#import "GLDIYAlertViewController.h"

@interface GLDIYActionSheetViewController ()

@property (nonatomic, strong) UIView *vBody;
@property (nonatomic, strong) UIView *vTitle;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbDesc;
@property (nonatomic, strong) UIView *vBtns;
@property (nonatomic, strong) UIView *vSpace;
@property (nonatomic, strong) UIView *vCancel;
@property (nonatomic, strong) UIView *vBottom;
@end

@implementation GLDIYActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.5);

    [self configBody];
}

- (void)configBody {
    UIView *vBody = [[UIView alloc] init];
    vBody.frame = CGRectMake(0, 0, GLUIKIT_SCREEN_WIDTH, 100);
    vBody.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vBody];
    self.vBody = vBody;

    self.vTitle = [[UIView alloc] init];
    self.vTitle.frame = CGRectMake(0, 0, GLUIKIT_SCREEN_WIDTH, 60);
    [self.vBody addSubview:self.vTitle];

    self.lbTitle = [[UILabel alloc] init];
    self.lbTitle.frame = CGRectMake(20, 0, GLUIKIT_SCREEN_WIDTH - 40, 24);
    self.lbTitle.textColor = UIColorFromRGB(0x222222);
    self.lbTitle.font = FONTSYS(17);
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.vTitle addSubview:self.lbTitle];

    self.lbDesc = [[UILabel alloc] init];
    self.lbDesc.frame = CGRectMake(20, 0, GLUIKIT_SCREEN_WIDTH - 40, 18);
    self.lbDesc.textColor = UIColorFromRGB(0x9a9a9a);
    self.lbDesc.font = FONTSYS(12);
    self.lbDesc.textAlignment = NSTextAlignmentCenter;
    [self.vTitle addSubview:self.lbDesc];

    self.vBtns = [[UIView alloc] init];
    self.vBtns.frame = CGRectMake(0, CGRectGetMaxY(self.vTitle.frame), GLUIKIT_SCREEN_WIDTH, 100);
    [self.vBody addSubview:self.vBtns];

    self.vSpace = [[UIView alloc] init];
    self.vSpace.frame = CGRectMake(0, CGRectGetMaxY(self.vBtns.frame), GLUIKIT_SCREEN_WIDTH, 8);
    self.vSpace.backgroundColor = UIColorFromRGB(0xF1F1F3);
    [self.vBody addSubview:self.vSpace];

    self.vCancel = [[UIView alloc] init];
    self.vCancel.frame = CGRectMake(0, CGRectGetMaxY(self.vSpace.frame), GLUIKIT_SCREEN_WIDTH, 56);
    [self.vBody addSubview:self.vCancel];

    self.vBottom = [[UIView alloc] init];
    if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
        self.vBottom.frame = CGRectMake(0, CGRectGetMaxY(self.vCancel.frame), GLUIKIT_SCREEN_WIDTH, 34);
    } else {
        self.vBottom.frame = CGRectMake(0, CGRectGetMaxY(self.vCancel.frame), GLUIKIT_SCREEN_WIDTH, 0);
    }
    [self.vBody addSubview:self.vBottom];

    [self update];
}

- (void)update {
    float offsetY = 0.0;
    float offsetInY = 0.0;
    CGRect rect;

    self.vTitle.hidden = YES;
    self.lbTitle.hidden = YES;
    self.lbDesc.hidden = YES;

    if (self.headline.length > 0 && self.msg.length > 0) {
        self.vTitle.hidden = NO;
        self.lbTitle.hidden = NO;
        self.lbDesc.hidden = NO;

        self.lbTitle.text = self.headline;
        self.lbDesc.text = self.msg;

        rect = self.lbTitle.frame;
        rect.origin.y = 12;
        self.lbTitle.frame = rect;

        rect = self.lbDesc.frame;
        rect.origin.y = 38;
        self.lbDesc.frame = rect;

        offsetInY = CGRectGetMaxY(self.lbDesc.frame);
    } else if (self.headline.length > 0 || self.msg.length > 0) {
        self.vTitle.hidden = NO;
        if (self.headline.length > 0) {
            self.lbTitle.hidden = NO;
            self.lbTitle.text = self.headline;

            rect = self.lbTitle.frame;
            rect.origin.y = 16;
            self.lbTitle.frame = rect;

            offsetInY = CGRectGetMaxY(self.lbTitle.frame);
        } else {
            self.lbDesc.hidden = NO;
            self.lbDesc.text = self.msg;

            rect = self.lbDesc.frame;
            rect.origin.y = 16;
            self.lbDesc.frame = rect;

            offsetInY = CGRectGetMaxY(self.lbDesc.frame);
        }
    } else {
        offsetInY = 0;
    }

    if (self.vContent) {
        [self.vTitle addSubview:self.vContent];

        rect = self.vContent.frame;
        rect.origin.y = offsetInY;
        self.vContent.frame = rect;

        offsetInY = CGRectGetMaxY(self.vContent.frame);
    }
    
    if (self.headline.length > 0 && self.msg.length > 0) {
        offsetInY = offsetInY + 12;
    }
    else if (self.headline.length > 0 || self.msg.length > 0) {
        offsetInY = offsetInY + 16;
    }
        
    if (offsetInY > 0) {
        self.vTitle.hidden = NO;

        rect = self.vTitle.frame;
        rect.size.height = offsetInY;
        self.vTitle.frame = rect;

        offsetY = CGRectGetMaxY(self.vTitle.frame);
    } else {
        self.vTitle.hidden = YES;
    }

    if (self.actions.count > 0) {
        self.vBtns.hidden = NO;
        for (UIView *view in self.vBtns.subviews) {
            [view removeFromSuperview];
        }

        NSMutableArray *btns = [[NSMutableArray alloc] init];

        for (int i = 0; i < self.actions.count; i++) {
            NSDictionary *action = self.actions[i];
            // 创建基础区域
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, GLUIKIT_SCREEN_WIDTH, 100);
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i;
            view.userInteractionEnabled = YES;

            UILabel *lbInTitle = [[UILabel alloc] init];
            lbInTitle.frame = CGRectMake(20, 0, GLUIKIT_SCREEN_WIDTH - 40, 22);
            lbInTitle.font = FONTSYS(16);
            lbInTitle.textColor = UIColorFromRGB(0x222222);
            lbInTitle.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lbInTitle];

            UILabel *lbInDesc = [[UILabel alloc] init];
            lbInDesc.frame = CGRectMake(20, 0, GLUIKIT_SCREEN_WIDTH - 40, 1000);
            lbInDesc.font = FONTSYS(12);
            lbInDesc.textColor = UIColorFromRGB(0x9a9a9a);
            lbInDesc.textAlignment = NSTextAlignmentCenter;
            lbInDesc.numberOfLines = 0;
            [view addSubview:lbInDesc];

            if ([action objectForKey:@"title"]) {
                lbInTitle.text = [action objectForKey:@"title"];
            }
            if ([action objectForKey:@"description"]) {
                lbInDesc.text = [action objectForKey:@"description"];

                lbInDesc.hidden = NO;

                rect = lbInTitle.frame;
                rect.origin.y = 12;
                lbInTitle.frame = rect;
                
                [lbInDesc sizeToFit];
                rect = lbInDesc.frame;
                rect.origin.y = 36;
                rect.origin.x = 20;
                rect.size.width = GLUIKIT_SCREEN_WIDTH - 40;
                lbInDesc.frame = rect;

                rect = view.frame;
                rect.size.height = CGRectGetMaxY(lbInDesc.frame) + 12;
                view.frame = rect;
            } else {
                lbInDesc.hidden = YES;

                rect = lbInTitle.frame;
                rect.origin.y = 18;
                lbInTitle.frame = rect;

                rect = view.frame;
                rect.size.height = 56;
                view.frame = rect;
            }

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtn:)];
            [view addGestureRecognizer:tap];

            [self.vBtns addSubview:view];
            [btns addObject:view];
        }

        offsetInY = 0.0;
        for (UIView *btn in btns) {
            // 创建基础线
            UIView *vLine = [[UIView alloc] init];
            vLine.frame = CGRectMake(0, offsetInY, GLUIKIT_SCREEN_WIDTH, 0.5);
            vLine.backgroundColor = UIColorFromRGB(0xeeeeee);
            [self.vBtns addSubview:vLine];

            CGRect rect = btn.frame;
            rect.origin.y = offsetInY;
            rect.origin.x = 0;
            rect.size.width = GLUIKIT_SCREEN_WIDTH;
            btn.frame = rect;

            offsetInY = CGRectGetMaxY(btn.frame);
        }

        rect = self.vBtns.frame;
        rect.origin.y = offsetY;
        rect.size.height = offsetInY;
        self.vBtns.frame = rect;

        offsetY = CGRectGetMaxY(self.vBtns.frame);
    } else {
        self.vBtns.hidden = YES;

        rect = self.vBtns.frame;
        rect.origin.y = offsetY;
        rect.size.height = 0;
        self.vBtns.frame = rect;
    }

    if (self.cancel) {
        self.vSpace.hidden = NO;

        rect = self.vSpace.frame;
        rect.origin.y = offsetY;
        self.vSpace.frame = rect;

        offsetY = CGRectGetMaxY(self.vSpace.frame);
    } else {
        self.vSpace.hidden = YES;
    }

    if (self.cancel) {
        self.vCancel.hidden = NO;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, GLUIKIT_SCREEN_WIDTH, 56);
        [btn setTitle:[self.cancel objectForKey:@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = FONTSYS(16);
        [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.vCancel addSubview:btn];

        rect = self.vCancel.frame;
        rect.size.height = 56;
        rect.origin.y = offsetY;
        self.vCancel.frame = rect;

        offsetY = CGRectGetMaxY(self.vCancel.frame);
    } else {
        self.vCancel.hidden = YES;
    }

    rect = self.vBottom.frame;
    rect.origin.y = offsetY;
    self.vBottom.frame = rect;

    rect = self.vBody.frame;
    rect.size.height = CGRectGetMaxY(self.vBottom.frame);
    rect.origin.y = GLUIKIT_SCREEN_HEIGHT - rect.size.height;
    self.vBody.frame = rect;
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.vBody.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = self.vBody.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    self.vBody.layer.mask = cornerRadiusLayer;
}

- (void)clickCancelBtn:(id)sender {
    GLAlertCenterClickBlock block = [self.cancel objectForKey:@"action"];
    if (block) {
        block();
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickBtn:(UITapGestureRecognizer *)tap {
    NSInteger tag = [tap.view tag];
    NSDictionary *action = [self.actions objectAtIndex:tag];

    GLAlertCenterClickBlock block = [action objectForKey:@"action"];
    if (block) {
        block();
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
