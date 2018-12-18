//
//  FQSeriesElement.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//  有几组展示几组.配置折线图

#import <UIKit/UIKit.h>
#import "FQXAxisItem.h"
#define rgba(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

typedef NS_ENUM(NSInteger,FQChartType) {
    FQChartType_Line = 0 ,        //折线图
    FQChartType_Bar ,      //垂直柱状图
    FQChartType_Pie,           //圆π图
    FQChartType_Point,        //点图
};

typedef NS_ENUM(NSInteger,FQChartYAxisAligmentType) {
    FQChartYAxisAligmentType_Left = 0,      //左边参考
    FQChartYAxisAligmentType_Right ,        //右边参考
};

typedef NS_ENUM(NSUInteger, FQModeType) {
    FQModeType_None, //没有圆角
    FQModeType_RoundedCorners, //圆角.直线就是圆滑形的.柱状图就是以柱状宽度为半径圆角
};

typedef NS_ENUM(NSInteger,ChartSelectLineType) {
    ChartSelectLineType_SolidLine = 0, //实线
    ChartSelectLineType_DottedLine ,   //虚线
};

@interface FQSeriesElement : NSObject


/**
 线的类型 - 柱状图.与折线图.均是居中显示
 */
@property (nonatomic, assign) FQChartType chartType;

/**
 圆角样式 - 线条就是润滑 - 柱状图就是有圆角
 */
@property (nonatomic, assign) FQModeType modeType;

/**
 提供一个只有数据的接口.x轴转换为0-count-1
 */
@property (nonatomic, strong) NSArray<NSNumber *> *orginNumberDatas;

/**
 源数据. - 主要是使用这个
 */
@property (nonatomic, strong) NSArray<FQXAxisItem *> *orginDatas;

/**
 相应图片对应的Y轴.默认为左边
 */
@property (nonatomic, assign) FQChartYAxisAligmentType yAxisAligmentType;

/**
 主要色.
 */
@property (nonatomic, strong) UIColor *mainColor;

/**
 渐变色 - 针对柱状图统一渐变.针对折线渲染的渐变-有值.则有渐变.
 */
@property (nonatomic, strong) NSArray *gradientColors;

// ---- 平均线相关

/**
 平均线条的颜色 - 如果不需要.可以设定为透明色.默认为透明
 */
@property (nonatomic, strong) UIColor *averageLineColor;

/**
 平均线条的类型
 */
@property (nonatomic, assign) ChartSelectLineType averageLineType;

/**
 平均线的值.
 */
@property (nonatomic, strong) NSNumber *averageNum;

// ---- 选中点相关
/**
 选中点颜色.默认为红色
 */
@property (nonatomic, strong) UIColor *selectPointColor;

#pragma mark - 折线图

/**
 绘制曲线宽度，默认2.00f
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 是否隐藏填充layer，默认NO
 */
@property (nonatomic, assign) BOOL fillLayerHidden;

/**
 当有渐变时.即gradientColors有值时.如为YES.渲染也有渐变.为NO.则使用背景色.默认为NO
 */
@property (nonatomic, assign) BOOL isGradientFillLayer;

/**
 填充layer的颜色，默认黑色，透明度0.2
 */
@property (nonatomic, strong) UIColor *fillLayerBackgroundColor;

#pragma mark - 垂直柱状图

/**
 占位色
 */
@property (nonatomic, strong) UIColor *barPlaceholderColor;

/**
 各组颜色 - 针对每种柱状图
 */
@property (nonatomic, strong) NSMutableArray *barColors;

/**
 柱状图的宽度 - 优先级高于柱状图间距
 */
@property (nonatomic, assign) CGFloat barWidth;

/**
 柱状图的间距 - 优先级低于柱状宽度
 */
@property (nonatomic, assign) CGFloat barSpacing;

#pragma mark - 圆饼图
/**
 各组颜色 - 针对每种柱状图.圆饼图颜色不一样时
 */
@property (nonatomic, strong) NSArray *pieColors;

/**
 对应展示的描述数组
 */
@property (nonatomic, strong) NSArray<NSString *> *showPieNameDatas;

/**
 圆饼中心的描述
 */
@property (nonatomic, copy) NSString *pieCenterDesc;

/**
 圆饼中心的单位
 */
@property (nonatomic, copy) NSString *pieCenterUnit;

/**
 圆饼图的半径.默认为100
 */
@property (nonatomic, assign) CGFloat pieRadius;

/**
 中心圆饼图的半径.默认为50
 */
@property (nonatomic, assign) CGFloat pieCenterMaskRadius;

/**
 饼状描述字体
 */
@property (nonatomic, strong) UIFont *pieDescFont;

/**
 饼状描述字体颜色
 */
@property (nonatomic, strong) UIColor *pieDescColor;

/**
 占比字体颜色
 */
@property (nonatomic, strong) UIColor *pieAccountedColor;

/**
 占比字体
 */
@property (nonatomic, strong) UIFont *pieAccountedFont;

/**
 中心圆饼的描述字体
 */
@property (nonatomic, strong) UIFont *pieCenterDescFont;

/**
 中心圆饼的描述字体颜色
 */
@property (nonatomic, strong) UIColor *pieCenterDescColor;

/**
 中心圆饼的单位字体
 */
@property (nonatomic, strong) UIFont *pieCenterUnitFont;

/**
 中心圆饼的单位字体颜色
 */
@property (nonatomic, strong) UIColor *pieCenterUnitColor;


@end

