//
//  FQHorizontalBarElement.h
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/4.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQHorizontalBarItem.h"

typedef NS_ENUM(NSInteger,ChartHorizontalBarContentType){ //水平柱状图.描述文本所处的位置
    ChartHorizontalBarContentType_Inside, //里面
    ChartHorizontalBarContentType_Top,    //底部
};

@interface FQHorizontalBarElement : NSObject

#pragma mark - 水平柱状图
/**
 与水平柱状图起点开始布局的文本视图.可以在柱状上.也可以在柱状里.取决于
 */
@property (nonatomic, strong) NSArray <FQHorizontalBarItem *>*horizontalBarItemArr;

/**
 水平柱状图描述文本位置类型
 */
@property (nonatomic, assign) ChartHorizontalBarContentType horizontalBarContentType;

/**
 是否显示左侧的文本描述
 */
@property (nonatomic, assign) BOOL isShowXLeftAxisStr;

/**
 是否显示右侧的文本描述
 */
@property (nonatomic, assign) BOOL isShowXRightAxisStr;

/**
 图片内容标题
 */
@property (nonatomic, copy) NSString *contentTitle;

/**
 x轴右侧标题
 */
@property (nonatomic, copy) NSString *xRightTitle;

/**
 x轴左侧标题
 */
@property (nonatomic, copy) NSString *xLeftAxisTitle;

/**
 图标底部描述文本
 */
@property (nonatomic, copy) NSString *horBarBotDesc;

/**
 图表底部右侧描述
 */
@property (nonatomic, copy) NSString *horBarBotRightDesc;

/**
 图表底部左侧描述
 */
@property (nonatomic, copy) NSString *horBarBotLeftDesc;

/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

// -------------- x轴左侧字体

/**
 x轴左侧字体文本字体
 */
@property (nonatomic, strong) UIFont *xLeftAxisLabFont;


/**
 x轴左侧字体文本字体颜色
 */
@property (nonatomic, strong) UIColor *xLeftAxisLabColor;

// -------------- x轴左侧选中字体

/**
 x轴左侧选中文本字体
 */
@property (nonatomic, strong) UIFont *xLeftAxisSelectLabFont;


/**
 x轴左侧选中文本字体颜色
 */
@property (nonatomic, strong) UIColor *xLeftAxisSelectLabColor;

// -------------- 图表内容部分-包含上部和里部文本字体

/**
 图表内容字体文本字体
 */
@property (nonatomic, strong) UIFont *contentLabFont;


/**
图表内容字体文本字体颜色
 */
@property (nonatomic, strong) UIColor *contentLabColor;

// -------------- 图表顶部部分文本字体

/**
 图表顶部字体文本字体
 */
@property (nonatomic, strong) UIFont *chartTopLabFont;


/**
 图表顶部字体文本字体颜色
 */
@property (nonatomic, strong) UIColor *chartTopLabColor;

// -------------- x轴右侧字体

/**
 x轴右侧字体文本字体
 */
@property (nonatomic, strong) UIFont *xRightAxisLabFont;


/**
 x轴右侧字体文本字体颜色
 */
@property (nonatomic, strong) UIColor *xRightAxisLabColor;

/**
 柱状占位色
 */
@property (nonatomic, strong) UIColor *barPlaceholderColor;

/**
 渐变色 - 针对柱状图统一渐变.针对折线渲染的渐变-有值.则有渐变.
 */
@property (nonatomic, strong) NSArray *gradientColors;

/**
 主要色.
 */
@property (nonatomic, strong) NSArray<UIColor *> *colors;

/**
 默认色
 */
@property (nonatomic, strong) UIColor *mainColor;

/**
 水平柱状图的高度.默认为18
 */
@property (nonatomic, assign) CGFloat horBarHeight;

/**
 水平柱状图柱子与content文本之间的间距.默认为2.
 */
@property (nonatomic, assign) CGFloat horBarMargin;

/**
 图标底部描述文本的颜色与字体
 */
@property (nonatomic, strong) UIColor *horBarBotDescColor;
@property (nonatomic, strong) UIFont *horBarBotDescFont;

/**
 图表底部右侧描述颜色与字体
 */
@property (nonatomic, strong) UIColor *horBarBotRightDescColor;
@property (nonatomic, strong) UIFont *horBarBotRightDescFont;

/**
 图表底部左侧描述颜色与字体
 */
@property (nonatomic, strong) UIColor *horBarBotLeftDescColor;
@property (nonatomic, strong) UIFont *horBarBotLeftDescFont;

/**
 水平柱状的最窄值.默认为horBarHeight的一半.
 */
@property (nonatomic, assign) CGFloat narrowestW;

/**
 水平柱状与左侧文本的间距.默认为5
 */
@property (nonatomic, assign) CGFloat barLeftMargin;

/**
 水平柱状与右侧文本的间距.默认为5
 */
@property (nonatomic, assign) CGFloat barRightMargin;

/**
 类似"-0'23''"文本的宽度.默认为30
 */
@property (nonatomic, assign) CGFloat barTopStrWidth;

/**
 水平柱状之间的间距.默认为5
 */
@property (nonatomic, assign) CGFloat barContentMargin;
@end

