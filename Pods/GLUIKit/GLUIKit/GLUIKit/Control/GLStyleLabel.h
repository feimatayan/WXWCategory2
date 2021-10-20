//
//  GLPadEditLabel.h
//  iShoppingIPadLib
//
//  Created by GuDongHui on 13-12-25.
//
//


#import "GLLabel.h"





@interface GLStyleLabel : GLLabel 

@property (nonatomic, assign) NSInteger compareOptionsType; ///< 区分识别字符串类型。默认0:区分大小写。1:不区分大小写。2。。。
@property (nonatomic, assign) BOOL isShowUnderline;         ///< 是否显示可点击关键字的下划线

@property (nonatomic, strong) UIColor *stringColor;         ///< 字符串的颜色
@property (nonatomic, strong) UIColor *keywordColor;        ///< 关键字的颜色
@property (nonatomic, strong) UIColor *clickKeyColor;       ///< 可点击关键字关键字的颜色

@property (nonatomic, strong) NSMutableArray *keywordList;  ///< 用于存储关键字的NSRange
@property (nonatomic, strong) NSMutableArray *clickArr;     ///< 用于存储可点击关键字的NSRange。



/**
 *  设置字符串颜色和关键字颜色
 *
 *  @param strColor 字符串颜色
 *  @param keyColor 关键字颜色
 *
 */
- (void)setUIlabelTextColor:(UIColor *)strColor andKeyWordColor:(UIColor *)keyColor;



/**
 * 设置显示的字符串和关键字。即将显示时调用此函数
 *
 * @param string   字符串
 * @param keyword  关键字
 *
 */
- (void)setUILabelText:(NSString *)string andKeyWord:(NSString *)keyword;



/**
 * 设置显示的字符串、关键字、可点击关键字。即将显示时调用此函数
 *
 * @param string   字符串
 * @param keyWordStrOrArr  关键字：字符串 或 数组
 * @param keyLickStrOrArr  可点击关键字：字符串 或 数组
 *
 */

- (void)setUI2LabelText:(NSString *)string andKeyWord_StrOrArr:(id)keyWordStrOrArr fromClick_StrOrArr:(id)keyLickStrOrArr;




/**
 * 设置点击事件
 *
 * @param clickBlock 处理事件
 *
 */

- (void)setClickKeyWordFromBlock:(void(^)(id clickInfo))clickBlock;



@end
