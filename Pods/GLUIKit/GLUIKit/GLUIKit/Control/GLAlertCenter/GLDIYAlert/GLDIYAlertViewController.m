//
//  GLDIYAlertViewController.m
//  GLUIKit
//
//  Created by smallsao on 2021/7/20.
//

#import "GLDIYAlertViewController.h"
#import "GLColorConstants.h"
#import "GLUIKitUtils.h"

@interface GLDIYAlertViewController ()

@property (nonatomic, strong) UIView *vBody;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbMsg;
@property (nonatomic, strong) UILabel *lbDesc;
@property (nonatomic, strong) UIView *vBtns;

@end

@implementation GLDIYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGBA(0x000000, 0.5);

    [self configBody];
}

- (void)configBody {
    UIView *vBody = [[UIView alloc] init];
    vBody.frame = CGRectMake((GLUIKIT_SCREEN_WIDTH - 300) / 2, 0, 300, 100);
    vBody.backgroundColor = [UIColor whiteColor];
    vBody.layer.cornerRadius = 8;
    [self.view addSubview:vBody];
    self.vBody = vBody;

    // 标题
    self.lbTitle = [[UILabel alloc] init];
    self.lbTitle.frame = CGRectMake(28, 28, 300 - 56, 28);
    self.lbTitle.textColor = UIColorFromRGB(0x222222);
    self.lbTitle.font = FONTBOLDSYS(18);
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    self.lbTitle.hidden = YES;
    [self.vBody addSubview:self.lbTitle];

    // 描述
    self.lbMsg = [[UILabel alloc] init];
    self.lbMsg.frame = CGRectMake(28, 60, 300 - 56, 1000);
    self.lbMsg.textColor = UIColorFromRGB(0x737373);
    self.lbMsg.font = FONTSYS(14);
    self.lbMsg.textAlignment = NSTextAlignmentCenter;
    self.lbMsg.numberOfLines = 0;
    self.lbMsg.hidden = YES;
    [self.vBody addSubview:self.lbMsg];

    // 只有标题或者描述
    self.lbDesc = [[UILabel alloc] init];
    self.lbDesc.frame = CGRectMake(28, 38, 300 - 56, 1000);
    self.lbDesc.textColor = UIColorFromRGB(0x222222);
    self.lbDesc.font = FONTSYS(18);
    self.lbDesc.textAlignment = NSTextAlignmentCenter;
    self.lbDesc.numberOfLines = 0;
    self.lbDesc.hidden = YES;
    [self.vBody addSubview:self.lbDesc];

    self.vBtns = [[UIView alloc] init];
    self.vBtns.frame = CGRectMake(0, 100, 300, 100);
    [self.vBody addSubview:self.vBtns];

    [self update];
}

- (void)update {
    float offsetY = 0.0;
    if (self.headline.length > 0 && self.msg.length > 0) {
        self.lbTitle.hidden = NO;
        self.lbMsg.hidden = NO;

        self.lbTitle.text = self.headline;
        self.lbMsg.text = self.msg;

        [self.lbMsg sizeToFit];

        offsetY = CGRectGetMaxY(self.lbMsg.frame) + 8;
    } else if (self.headline.length > 0 || self.msg.length > 0) {
        self.lbDesc.hidden = NO;
        if (self.headline.length > 0) {
            self.lbDesc.text = self.headline;
        }
        if (self.msg.length > 0) {
            self.lbDesc.text = self.msg;
        }

        [self.lbDesc sizeToFit];

        offsetY = CGRectGetMaxY(self.lbDesc.frame) + 8;
    } else {
        offsetY = 28;
    }

    if (self.vContent) {
        [self.vBody addSubview:self.vContent];

        CGRect rect = self.vContent.frame;
        rect.origin.y = offsetY;
        self.vContent.frame = rect;

        offsetY = CGRectGetMaxY(self.vContent.frame) + 8;
    }

    offsetY = offsetY + 20;
    if (self.actions.count > 0) {
        for (UIView *view in self.vBtns.subviews) {
            [view removeFromSuperview];
        }

        NSMutableArray *btns = [[NSMutableArray alloc] init];

        BOOL isBtnTooLong = NO;
        float offsetInY = 0.0;

        for (int i = 0; i < self.actions.count; i++) {
            NSDictionary *action = self.actions[i];
            // 创建基础按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[action objectForKey:@"title"] forState:UIControlStateNormal];
            btn.titleLabel.font = FONTSYS(16);
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.vBtns addSubview:btn];

            if (i == 0) {
                [btn setTitleColor:UIColorFromRGB(0x297CE6) forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:UIColorFromRGB(0x737373) forState:UIControlStateNormal];
            }

            if ([self btnWidth:[action objectForKey:@"title"]] > 120) {
                isBtnTooLong = YES;
            }

            [btns addObject:btn];
        }

        if (btns.count > 2 || btns.count == 1) {
            isBtnTooLong = YES;
        }

        if (isBtnTooLong) {
            for (UIView *btn in btns) {
                // 创建基础线
                UIView *vLine = [[UIView alloc] init];
                vLine.frame = CGRectMake(0, offsetInY, 300, 0.5);
                vLine.backgroundColor = UIColorFromRGB(0xeeeeee);
                [self.vBtns addSubview:vLine];

                CGRect rect = btn.frame;
                rect.origin.y = offsetInY;
                rect.origin.x = 0;
                rect.size.width = 300;
                rect.size.height = 44;
                btn.frame = rect;

                offsetInY = CGRectGetMaxY(btn.frame);
            }
        } else {
            if (btns.count == 2) {
                // 创建基础线
                UIView *vLine = [[UIView alloc] init];
                vLine.frame = CGRectMake(0, offsetInY, 300, 0.5);
                vLine.backgroundColor = UIColorFromRGB(0xeeeeee);
                [self.vBtns addSubview:vLine];

                UIButton *btn1 = [btns objectAtIndex:0];
                CGRect rect = btn1.frame;
                rect.size.width = 150;
                rect.origin.y = 0;
                rect.size.height = 44;
                rect.origin.x = 150;
                btn1.frame = rect;
                
                UIView *vLine2 = [[UIView alloc] init];
                vLine2.frame = CGRectMake(150, 0, 0.5, 44);
                vLine2.backgroundColor = UIColorFromRGB(0xeeeeee);
                [self.vBtns addSubview:vLine2];
                
                UIButton *btn2 = [btns objectAtIndex:1];
                rect = btn2.frame;
                rect.size.width = 150;
                rect.origin.y = 0;
                rect.size.height = 44;
                rect.origin.x = 0;
                btn2.frame = rect;
                
                offsetInY = 44;
            }
        }

        CGRect rect = self.vBtns.frame;
        rect.origin.y = offsetY;
        rect.size.height = offsetInY;
        self.vBtns.frame = rect;

        rect = self.vBody.frame;
        rect.size.height = CGRectGetMaxY(self.vBtns.frame);
        rect.origin.y = (GLUIKIT_SCREEN_HEIGHT - rect.size.height) / 2;
        self.vBody.frame = rect;
    }
}

- (void)clickBtn:(id)sender {
    NSInteger tag = [sender tag];
    NSDictionary *action = [self.actions objectAtIndex:tag];

    GLAlertCenterClickBlock block = [action objectForKey:@"action"];
    if (block) {
        block();
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (float)btnWidth:(NSString *)title {
    UILabel *lb = [[UILabel alloc] init];
    lb.frame = CGRectMake(0, 0, 10000, 20);
    lb.font = FONTSYS(16);
    lb.text = title;
    [lb sizeToFit];

    return lb.frame.size.width;
}

@end
