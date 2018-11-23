//
//  FQChartConfiguration.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQSeriesElement.h"
#import "FQPopTipView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,XAxisOhterPointChartType) {
    XAxisPointChartType_Hidden = 0, //隐藏
    XAxisPointChartType_Dot ,       //点
    XAxisPointChartType_Show       //显示
};

typedef NS_ENUM(NSInteger,ChartViewUnitDescrType) {
    ChartViewUnitDescrType_Top = 0, //上边
    ChartViewUnitDescrType_LeftRight ,//左侧Y轴在左侧.右边Y轴在右侧.
};


@interface FQChartConfiguration : NSObject

#pragma mark - X轴

#pragma mark - 优先级最高
/**
 显示出来的X轴的值.只想显示其中的是文字.这种只适用等分 @[20180103,20180203,20180303]
 */
@property (nonatomic, strong) NSArray<NSString *> *showXAxisStringDatas;

/**
 显示出来的X轴值.这种会根据X轴的数据去展示. [@1,@3,@7,@8]
 */
@property (nonatomic, strong) NSArray<NSString *> *showXAxisStringNumberDatas;

#pragma mark -优先级居中
/**
 显示出来的X轴的值.间隔.默认为0.例如.间隔为2.那么针对1,2,3.....24.取出来为.1.4.7...
 */
@property (nonatomic, assign) NSInteger showXAxisInterval;

#pragma mark - 优先级最低
//默认为最小到最大全部排列.所以需要自己定义.

/**
 针对未显示出来的X轴点.可以将其隐藏或者变为黑点 - 待定
 */
@property (nonatomic, assign) XAxisOhterPointChartType xAxisOhterType;

/**
 x轴是否在底部.默认为YES.设定为NO就在顶部 - 这个是底部.
 */
@property (nonatomic, assign) BOOL xAxisIsBottom;

/**
 是否隐藏X轴
 */
@property (nonatomic, assign) BOOL hiddenXAxis;

/**
 是否显示X轴标识.默认为No.
 */
@property (nonatomic, assign) BOOL isShowXAxisFlag;

#pragma mark - y轴

/**
 y轴数据显示是否倒序.默认为NO.
 */
@property (nonatomic, assign) BOOL yAxisIsReverse;
/**
 描述位置.
 */
@property (nonatomic, assign) ChartViewUnitDescrType unitDescrType;
/**
 左Y轴单位
 */
@property (nonatomic, copy) NSString *yAxisLeftTitle;

/**
 右Y轴单位
 */
@property (nonatomic, copy) NSString *yAxisRightTitle;

/**
 左Y轴单位字体
 */
@property (nonatomic, strong) UIFont *yAxisLeftTitleFont;

/**
 右Y轴单位字体
 */
@property (nonatomic, strong) UIFont *yAxisRightTitleFont;

/**
 左Y轴单位颜色
 */
@property (nonatomic, strong) UIColor *yAxisLeftTitleColor;

/**
 右Y轴单位颜色
 */
@property (nonatomic, strong) UIColor *yAxisRightTitleColor;

/**
 实际显示那几条.Y轴坐标以showLeftYAxisDatas为标准.若不存在showLeftYAxisDatas.那就默认均等分.
 */
@property (nonatomic, strong) NSArray<NSString *> *showLeftYAxisNames;

/**
 实际显示那几条.Y轴坐标以showRightYAxisDatas为标准.若不存在showRightYAxisDatas.那就默认均等分.
 */
@property (nonatomic, strong) NSArray<NSString *> *showRightYAxisNames;

#pragma mark - 优先级最高

/**
 左Y轴点数据源.可以直接从指定的点开始@[@5,@10,@20].是否存在.
 */
@property (nonatomic, strong) NSArray<NSNumber *> *showLeftYAxisDatas;

/**
 右Y轴点数据源.可以直接从指定的点开始@[@5,@10,@20].是否存在
 */
@property (nonatomic, strong) NSArray<NSNumber *> *showRightYAxisDatas;

#pragma mark - 优先级第二

//设定最大值
@property (nonatomic, assign) NSNumber * yLeftAxisMaxNumber;

//设定最小值
@property (nonatomic, assign) NSNumber * yLeftAxisMinNumber;

//设定最大值
@property (nonatomic, assign) NSNumber * yRightAxisMaxNumber;

//设定最小值
@property (nonatomic, assign) NSNumber * yRightAxisMinNumber;

#pragma mark - 优先级最小 - 默认.
//如果没有就从0到最大.等分5次排列.

/**
 是否隐藏左边Y轴.默认为YES
 */
@property (nonatomic, assign) BOOL hiddenLeftYAxis;

/**
 是否隐藏右边Y轴.默认为YES.
 */
@property (nonatomic, assign) BOOL hiddenRightYAxis;


#pragma mark - 其他数据

/**
 平均值.每个区间的一个平均值,有则显示.没有则不显示
 */
@property (nonatomic, strong) NSMutableArray *averageDatas;

/**
 平均值.如果有平均值.则显示平均线.否则不显示平均线
 */
@property (nonatomic, strong) NSNumber *averageData;


#pragma mark - 图表数据

//叠加图.一般叠加图使用均是同一组x轴数据.即个数一致
@property (nonatomic, strong) NSArray <FQSeriesElement *>*elements;

#pragma mark - 图表设定
#warning 还待完善------------
/**
 是否显示图例
 */
@property (nonatomic, assign) BOOL isShowLegend;

#pragma mark - 布局相关.
/**
 整个ChartView的内边距
 */
@property (nonatomic, assign) UIEdgeInsets chartViewEdgeInsets;

/**
 图表视图(包含X.Y轴)背景色的内边距
 */
@property (nonatomic, assign) UIEdgeInsets chartBackLayerEdgeInsets;

/**
 图表背景色(包含X.Y轴)
 */
@property (nonatomic, strong) UIColor * chartBackLayerColor;

/**
 图表视图(不包含X.Y)背景色
 */
@property (nonatomic, strong) UIColor *mainContainerBackColor;

/**
 默认Y轴显示个数.默认为5
 */
@property (nonatomic, assign) NSInteger kDefaultYAxisNames;

/**
 x轴描述距离X轴的间距.默认为5.0
 */
@property (nonatomic, assign) CGFloat kXAxisLabelTop;

/**
 y轴描述距离y轴的间距.默认为5.0
 */
@property (nonatomic, assign) CGFloat kYAxisLabelMargin;

/**
 y轴描述距离chartView的间距.默认为10.0
 */
@property (nonatomic, assign) CGFloat kYAxisChartViewMargin;

/**
 单位距离.y轴的间距.默认为10.0
 */
@property (nonatomic, assign) CGFloat kYTitleLabelBot;

/**
 y轴描述的宽度.默认为40.0
 */
@property (nonatomic, assign) CGFloat kChartViewWidthMargin;

/**
 x轴描述的高度.默认为40.0
 */
@property (nonatomic, assign) CGFloat kChartViewHeightMargin;


// ---- popView相关
/**
 是否显示popView.默认为Yes
 */
@property (nonatomic, assign) BOOL isShowPopView;

/**
 popView的箭头所在位置
 */
@property (nonatomic, assign) FQArrowDirection popArrowDirection;

/**
 contentView的背景色
 */
@property (nonatomic, strong) UIColor *popContentBackColor;

/**
 想自定义popTipView.直接传入该对象.不传则默认是用String样式.
 */
@property (nonatomic, strong) FQPopTipView *customPopTip;

// ---- 选中线相关

/**
 选中线条的颜色 - 如果不需要.可以设定为透明色.
 */
@property (nonatomic, strong) UIColor *currentLineColor;

/**
 选中线条的类型
 */
@property (nonatomic, assign) ChartSelectLineType selectLineType;

// ----- 选中点相关

/**
 是否显示选中点.默认为YES
 */
@property (nonatomic, assign) BOOL isShowSelectPoint;

/**
 选中点颜色.默认为红色
 */
@property (nonatomic, strong) UIColor *selectPointColor;

/**
 选中点是否需要白色边框.默认为YES
 */
@property (nonatomic, assign) BOOL isSelectPointBorder;


#pragma 动画相关
//绘制的时候是否需要动画，默认YES
@property (nonatomic, assign) BOOL drawWithAnimation;
//绘制动画时间，默认0.0s
@property (nonatomic, assign) CGFloat drawAnimationDuration;


#pragma 网格线相关
//是否隐藏x轴方向(水平)网格线，默认NO
@property (nonatomic, assign) BOOL xAxisGridHidden;
//是否隐藏y轴方向(竖直)网格线，默认NO
@property (nonatomic, assign) BOOL yAxisGridHidden;
//网格线宽度，默认1
@property (nonatomic, assign) CGFloat gridLineWidth;
//网格线颜色，默认黑色,
@property (nonatomic, strong) UIColor *gridLineColor;
//行网格线数量，默认10
@property (nonatomic, assign) NSUInteger gridRowCount;
//列网格线数量，默认10
@property (nonatomic, assign) NSUInteger gridColumnCount;

#pragma columnLabels,列标相关
//x轴label的颜色, 默认黑色
@property (nonatomic, strong) UIColor *xAxisLabelsTitleColor;
//x轴label的字体，默认12
@property (nonatomic, strong) UIFont *xAxisLabelsTitleFont;


#pragma rowLabels,行标相关
//y轴label的颜色, 默认黑色
@property (nonatomic, strong) UIColor *yAxisLabelsTitleColor;
//y轴label的字体，默认12
@property (nonatomic, strong) UIFont *yAxisLabelsTitleFont;
//y轴的宽度固定.
//@property (nonatomic, assign) CGFloat yAxisLabelsWidth;

#pragma 手势相关
//是否开启长按手势，开启手势后长按会通过代理将手指所在位置的最近的坐标和对应的值返回，默认开启
@property (nonatomic, assign) BOOL gestureEnabel;
//手势触发最短时间，默认0.5f
@property (nonatomic, assign) CGFloat minimumPressDuration;
@end

NS_ASSUME_NONNULL_END
