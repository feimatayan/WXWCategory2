//
//  GLMulTagLabel.h
//  iShopIPhoneLib
//
//  Created by jfzhao on 14-3-31.
//
//

#import "GLView.h"

#define RGBCOLORSTR(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define  tagNormalTextcolor         RGBCOLORSTR(0x919191)
#define  tagLinkTextcolor           RGBCOLORSTR(0x0e78c3)
#define  tagTextcolor               RGBCOLORSTR(0xfc5c30)

@protocol GLMulTagLabelDelegate<NSObject>
@optional

-(void)clickedTag:(NSInteger)index range:(NSRange) tagRange;

@end


// -------------------------------
//
// 带有链接的label
//
// -------------------------------
@interface GLMulTagLabel : GLView
{
    NSMutableArray* _tagRange;
    NSMutableArray* _linkRange;
    
    CGFloat           _textHeight;
}
@property(nonatomic,retain) NSString *strText;
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic,retain) UIColor *tagColor;
@property(nonatomic,retain) UIColor *linkColor;
@property(nonatomic,retain) UIFont  *font;                      // default is nil (system font 17 plain)
@property(nonatomic)        NSTextAlignment    textAlignment;   // default is NSTextAlignmentLeft
@property(nonatomic)        BOOL    isLinkShowUnderline;
@property(nonatomic)        BOOL    textVAlignmentCenter;        //text 垂直居中

//attribute
@property(nonatomic, retain) NSMutableAttributedString *attriText;
@property(nonatomic, assign) id<GLMulTagLabelDelegate> clickDelegate;


//赋值并布局
- (void) setText:(NSString *)aText;
- (void) setText:(NSString *)aText tags:(NSString*)aTags;
- (void) setText:(NSString *)aText tags:(NSString*)aTags link:(NSArray*)arrName;


@end
