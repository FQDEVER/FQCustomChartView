//
//  FQPopTipView.h
//  pop_test
//
//  Created by fanqi on 2018/11/21.
//  Copyright © 2018年 tuhui－03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger,FQArrowDirection){
    //箭头位置
    FQArrowDirectionDOWN = 0,//下
    FQArrowDirectionUP,//上
};


@interface FQPopTipView : UIView

/**
 标识高度 - 即箭头的竖直高度 默认为20
 */
@property (nonatomic, assign) CGFloat marginSpcingH;

/**
 标识底部宽度 - 即箭头最大宽度.默认为40
 */
@property (nonatomic, assign) CGFloat marginSpcingW;

/**
 popView展示类型的圆角大小
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 contentView的背景色
 */
@property (nonatomic, strong) UIColor *contentBackColor;

/**
 内容字符串
 */
@property (nonatomic, copy) NSString *contentTextStr;

/**
 是否添加阴影
 */
@property (nonatomic, assign) BOOL isShadow;


/**
 如果只有文本展示.则使用该方法
 
 @param direction 箭头在上或下
 @param maxX popView控件最大X值
 @param minX popView控件最小X值
 @param edgeInsets 内间距
 @param contentText 文本内容
 @param textColor 文本颜色
 @param textFont 文本字体
 @return popView
 */
+(instancetype)initWithPopViewWithDirection:(FQArrowDirection )direction maxX:(CGFloat)maxX minX:(CGFloat)minX edge:(UIEdgeInsets)edgeInsets contentText:(NSString *)contentText textColor:(UIColor*)textColor textFont:(UIFont *)textFont;

/**
 自定义视图.则使用该方法
 
 @param direction 箭头在上或下
 @param maxX popView控件最大X值
 @param minX popView控件最小X值
 @param edgeInsets 内间距
 @param customView 自定义控件
 @param customViewSize 自定义控件Size.用来获取popView的Size
 @return popView
 */
+(instancetype)initWithPopViewWithDirection:(FQArrowDirection )direction maxX:(CGFloat)maxX minX:(CGFloat)minX edge:(UIEdgeInsets)edgeInsets customView:(UIView *)customView andCustomSize:(CGSize)customViewSize;


/**
 开始绘制的原点位置
 
 @param origin 原点
 */
-(void)fq_drawRectWithOrigin:(CGPoint)origin;


@end

